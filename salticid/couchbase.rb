require 'fileutils'

role :couchbase do
  task :setup do
    sudo do
      exec! 'yum -y install pkgconfig', echo: true
      unless exec! 'find couchbase-server-enterprise_2.2.0_x86_64.rpm'
        exec! 'wget http://packages.couchbase.com/releases/2.2.0/couchbase-server-enterprise_2.2.0_x86_64.rpm', echo: true
      end
      begin
        log 'Removing old couchbase-server'
      	exec! 'rpm -e couchbase-server', echo: true
      rescue => e
        log 'Unable to remove couchbase server'
      end
      begin
        log 'Installing couchbase-server'
        exec! 'rpm -i ~/couchbase-server*', echo: true
      rescue => e
	log 'unable to install couchbase server'
	throw
      end
    end
  end

  task :cluster do
    sudo do
      if name == 'n1'
        log 'Setting up auth credentials: Administrator:password'
        exec! 'curl -s -d "username=Administrator&password=password&port=SAME" http://localhost:8091/settings/web'

        log 'Setting up memory quota: 2000MB'
        exec! 'curl -s -u Administrator:password -d "memoryQuota=2000" http://localhost:8091/pools/default'

        ips = Array.new(6)
        ips[1] = `cat /etc/hosts | grep -e n1$ | grep -v localhost | awk '{ print $1 }'`.strip!
        for i in 2..5
          ips[i] = `cat /etc/hosts | grep -e n#{i}$ | grep -v localhost | awk '{ print $1 }'`.strip!
          log 'Adding node n%i(%s) to cluster' % [i, ips[i]]
          exec! 'curl -s -u Administrator:password -d "hostname=%s&user=Administrator&password=password" http://localhost:8091/controller/addNode' % ips[i], echo: true
        end

        log 'Rebalancing cluster ...'
        exec! 'curl -s -u Administrator:password -d "ejectedNodes=&knownNodes=ns_1@%s,ns_1@%s,ns_1@%s,ns_1@%s,ns_1@%s" http://localhost:8091/controller/rebalance' % ips[1..5], echo: true
        sleep 30

        log 'Creating data bucket'
        exec! 'curl -s -u Administrator:password -d "name=bucket-0&ramQuotaMB=2000&authType=none&replicaNumber=1&proxyPort=11215" http://localhost:8091/pools/default/buckets', echo: true
      end 
    end
  end
end


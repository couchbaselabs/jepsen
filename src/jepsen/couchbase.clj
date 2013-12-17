(ns jepsen.couchbase
  (:use jepsen.util
        jepsen.set-app)
  (:require [cbdrawer.client :as cbc])
  (:import [java.net URI]))

(defn couchbase-app
  [opts]
  (let [k       (get opts :key "111")
        conn    (cbc/client "bucket-0" "" "http://n1:8091/")]

    (reify SetApp
      (setup [app]
          (cbc/force! conn k (list )))

      (add [app element]
          (let [res (cbc/cas! conn k 
                             conj element)])) 

      (results [app]
           (set (cbc/get conn k)))

      (teardown [app]
                (cbc/shutdown conn))
 ))) 

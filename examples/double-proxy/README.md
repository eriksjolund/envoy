Modify double-proxy example so that it uses mTLS (SNI) to serve two different postgres backends

                                                                                                                                                                                                                                     +-------------------------+
                                                                                                                                                                                                                                     |                         |
                                                                                                                                                                                                                              +------| postgres-1 (version 12) |
    +----------------+      +------------+        port 5432 +-------------------------+                                        mTLS (SNI)                                         +-----------------------------------+       |      |                         |
    |                |      |            |----------------->|                         |  proxy-postgres-frontend-1.example.com.csr --> proxy-postgres-backend-1.example.com.csr   |                                   |-------+      +-------------------------+
    | Envoy (front)  |----->|   Flask    |        port 5433 | Envoy (postgres-front)  |------------------------------------------------------------------------------------------>|    Envoy (postgres-backend)       |                                        
    |                |      |            |----------------->|                         |  proxy-postgres-frontend-2.example.com.csr --> proxy-postgres-backend-2.example.com.csr   |                                   |-------+      +-------------------------+
    +----------------+      +------------+                  +-------------------------+                                                                                           +-----------------------------------+       |      |                         |
                                                                                                                                                                                                                              +------| postgres-2 (version 13) |
                                                                                                                                                                                                                                     |                         |
                                                                                                                                                                                                                                     +-------------------------+

Old documentation:                                                                                                                                                                                                        
                                                                                                                                                                                                        
To learn about this sandbox and for instructions on how to run it please head over
to the [Envoy docs](https://www.envoyproxy.io/docs/envoy/latest/start/sandboxes/double-proxy.html).

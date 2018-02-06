import xkey;
sub vcl_deliver {
    set resp.http.nexteuropa_varnish_vcl = "enabled";
}

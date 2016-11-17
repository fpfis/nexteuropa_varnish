About Varnish
=============
Varnish is a very fast reverse-proxy system which is serving static 
files and anonymous page views based on the previously processed
requests.

Nexteuropa Varnish
==================
The Nexteuropa Varnish module provides functionality which allows to
send customized HTTP request to the Varnish server based on the
configured 'purge rules'.
Main purpose of those requests is to invalidate the Varnish cache to
reflect recently published content changes.

### Requirements
This feature can be enabled only with the support of the QA/Maintenance
team.
Following variables which are specific to the given environment have to
be configured before enabling the feature:
- 'nexteuropa_varnish_request_user' 
- 'nexteuropa_varnish_request_password'
- 'nexteuropa_varnish_http_targets',
- 'nexteuropa_varnish_tag',
- 'nexteuropa_varnish_request_method'

In order to enable the feature make sure that above variables are set
and if so then go to the `admin/structure/feature-set` page select
'Rule-based web frontend cache purging' and click 'Validate' button.

### Custom entity - 'Purge rule'
The Nexteuropa Varnish provides additional custom entity type:
- Purge rule - machine name: `nexteuropa_varnish_cache_purge_rule`

It allows to create and maintain a set of rules which are responsible
for sending customized HTTP requests to the Varnish server and by
that invalidating the frontend cache.

To add and maintain purge rules go to the following url:
`admin/config/frontend_cache_purge_rules`

### Purge rules logic
The Nexteuropa Varnish provides hardcoded logic for triggering
configured rules. Current version implements two workflow cases for:
- content types moderated via the workbench moderation module
- content types without additional moderation (default Drupal settings)
#### Content moderated via the workbench moderation module
For the content types which are controlled via workbench moderation
module, created purge rules would be triggered in the following cases:
- always when the given content would have a workflow state change to 'Published'
- always when the given content would have a workflow state change from 'Published' to the other
#### Content without moderation
For the content types which are not moderated (default Drupal content
type with two states published and unpublished), created purge rules
would be triggered in the following cases:
- when the node of the given content type would be created and saved with the 'Publish' state
- when the published node of the given content type would be updated

## Tests and custom Behat Feature Context
The Nexteuropa Varnish provides complete Behat test suite and additional
Feature Context located in the FrontendCacheContext class.

Tests are performed against mocked HTTP server. Only difference is that
mocked HTTP server doesn't support 'PURGE' method and instead of it
'POST' method is used.

You can find Behat scenarios in the frontend_cache_purge.feature file
which is located test folder.

## Developer's notes
The Nexteuropa Varnish uses https://www.drupal.org/project/chr module
which is overriding default `drupal_http_request()` function.

Specifically for this feature the custom patch was created.
You can find the patch [here](https://www.drupal.org/files/issues/chr-purge-2825701-2.patch)

Patch adds 'PURGE' HTTP method which is commonly used by systems such
as Varnish, Squid and SAAS CDNs like Fastly to clear cached versions of
certain paths.

All of HTTP requests are send by the `_nexteuropa_varnish_purge_paths()`
function.

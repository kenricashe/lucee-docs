<!--
{
  "title": "Breaking Changes Between Lucee 6.2 and 7.0",
  "id": "breaking-changes-6-2-to-7-0",
  "categories": ["breaking changes", "migration","compat"],
  "description": "A guide to breaking changes introduced in Lucee between version 6.2 and 7.0",
  "keywords": ["breaking changes", "Lucee 6.2", "Lucee 7.0", "migration", "upgrade"],
  "related": [
    "tag-application",
	"single-vs-multi-mode"
  ]
}
-->

# Breaking Changes between Lucee 6.2 and 7.0

This document outlines the breaking changes introduced when upgrading from Lucee 6.2 to Lucee 7.0.

Be aware of these changes when migrating your applications to ensure smooth compatibility.

[7.0 Changelog](https://download.lucee.org/changelog/?version=7.0)

[New Functions and Tags](https://docs.lucee.org/reference/changelog.html)

## Other Breaking Changes in Lucee Releases

- [[breaking-changes-5-4-to-6-0]]
- [[breaking-changes-6-0-to-6-1]]
- [[breaking-changes-6-1-to-6-2]]

## Java Support

- Java 24 for best performance!
- Java 21
- Java 11 is supported, but it's slower
- **Java 8 is no longer supported**

## Switching to Jakarta (from Javax)

Lucee 6.2 introduced support for jakarta (Tomcat 10+) etc, but was still javax based

Lucee 7.0 is now based on [Jakarta](https://jakarta.ee/). As such, Tomcat 9.0 (or older) is no longer supported, we recommend doing a fresh install.

[LDEV-4910](https://luceeserver.atlassian.net/browse/LDEV-4910)

[Lucee/script-runner](https://github.com/lucee/script-runner/releases/tag/1.2) was updated to include [jakarta.jakartaee-api](https://github.com/lucee/script-runner/commit/0b2750cdbf0af746ba40ae74a0510eeaf4de6fd1)

[Javax to Jakarta Namespace Ecosystem Progress](https://jakarta.ee/blogs/javax-jakartaee-namespace-ecosystem-progress/)

## Loader Change

Lucee 7.0 we have changed the Loader API, so that in place upgrades via the admin aren't supported OOTB.

The Loader Jar is found in the `lucee/lib` directory, i.e. `lucee-6.2.0.321.jar`.

To upgrade to Lucee 7.0 (if you are already running Tomcat 10.1), you will need to 

- Stop Lucee
- Replace that jar with a 7.0 version (`lucee.jar`) from [https://download.lucee.org/](https://download.lucee.org/)
- Restart Lucee.

The latest 5.4 and 6.2 releases will automatically ignore any attempts to do an in place upgrade, if the Loader jar is unsupported.

If you try upgrading an older release without these loader version checks, you will get a 500 error on startup. 

To get your Lucee instance back up and running if you experience this problem, stop Lucee and delete any lucee 7 `.lco` files from `lucee/tomcat/lucee-server/patches` and restart.

## Single Mode Only

Lucee 7.0 only supports Single Mode, which was introduced with Lucee 6.0.

[[single-vs-multi-mode]]

## Properly Scope Internal Tag Variables in Lucee Functions

Prior to Lucee 7, tag results like `CFQUERY`, `CFLOCK`, `CFFILE`, `CFTHREAD` were written into the default variables scope.

With Lucee 7, when these tags are used within a function, these are now written to the local scope.

This should have minimal impact on existing code and may avoid some concurrency race conditions, hence the change.

[LDEV-5416](https://luceeserver.atlassian.net/browse/LDEV-5416)

## Enable Limit evaluation by default

Adopting secure defaults, Lucee 7 by default sets this to true

[LDEV-5177](https://luceeserver.atlassian.net/browse/LDEV-5177)

## Enabled correct encoding of spaces in urls with CFHTTP

Older versions of Lucee double encoded spaces in CFHTTP, causing problems calling some APIs

[LDEV-3349](https://luceeserver.atlassian.net/browse/LDEV-3349)

## Remove support for loginStorage="cookie" and sessionStorage="cookie"

These are insecure and seldom used

[LDEV-5403](https://luceeserver.atlassian.net/browse/LDEV-5403)

## Enable quoted-printable for CFMAIL by default

For better HTML email support, Lucee 7 defaults to 7-bit encoding

[LDEV-4039](https://luceeserver.atlassian.net/browse/LDEV-4039)

## EHCache is no longer bundled

Still available as an extension, it is just no longer bundled in the default distribution.

This reduced the size of the full `lucee.jar` from 84 Mb to 64 Mb.

[LDEV-5267](https://luceeserver.atlassian.net/browse/LDEV-5267)

LDEV-5485

## Enable LUCEE_COMPILER_BLOCK_BYTECODE by default

Prevents cfml files containing java bytecode from being executed

[LDEV-5485](https://luceeserver.atlassian.net/browse/LDEV-5485)
[Lucee CVE-2024-55354](https://dev.lucee.org/t/lucee-cve-2024-55354-security-advisory-april-2025/14963)

# Pending changes (not yet implemented)

All proposed changes are listed in the sprint board for 7.0

[https://luceeserver.atlassian.net/jira/software/c/projects/LDEV/boards/53?label=breaking-change&sprint=73&sprints=73](https://luceeserver.atlassian.net/jira/software/c/projects/LDEV/boards/53?label=breaking-change&sprint=73&sprints=73)

Please raise any discussions regarding these changes on the dev forum, not in the individual tickets

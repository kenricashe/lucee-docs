---
title: QueryAddRow
id: function-queryaddrow
related:
- function-querysetcell
categories:
- query
description: Adds rows to a query, either empty row(s) or you can add a row with data
---

Adds rows to a query, either empty row(s) or you can add a row with data.

The number returned is the new row count of the query.

Lucee 6 changed the return value for the member function `.addrow()` from the number of rows, to the modified query, matching ACF

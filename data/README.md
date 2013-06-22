# README

The `data` folder hosts a few of the course datasets. The data are generally downloaded and immediately saved to comma-separated values.

| name                        | description                                                        | Session |
|:----------------------------|:-------------------------------------------------------------------|:--------|
| `grades.2012.txt` (*)       | Anonymized student grades from an Autumn 2012 math course          | 2.2 |
| `nhis.2005.txt` (*)         | Data extract from the U.S. National Health Interview Survey, 2005  | 2.2 |
| `us.recessions.4807.txt`    | BLS employment figures for NBER recession months, 1948-2013        | 3.1 |
| `browsers.0813.txt`         | StatCounter browser usage shares 2008-2013, scraped from Wikipedia | 3.3 (practice) |
| `wdi.govdebt.0511.txt`      | World Bank central governmental debt for 5 states, 2005-2011       | 4.0 |
| `dailykos.votes.0812.txt`   | U.S. 2008-2012 county-level vote shares from Daily Kos             | 4.1 |
| `qog.cs.txt`                | Quality of Government Standard cross-section, 15 May 2013          | 4.1, 5.3, 8.2, 10.0 |
| `arab.springs.txt`          | List of Arab Spring events, scraped from Wikipedia                 | 4.1 |
| `fide` (data folder)        | FIDE ratings for chess players, scraped from its website, 2013     | 4.1 |
| `htus8008` (data folder)    | Bureau of Justice Statistics on U.S. homicide trends, 1980-2008    | 4.2 |
| `schiller.8712.txt` (*)     | Standard and Poor's Case-Schiller Index for U.S. cities, 1987-2012 | 4.2 |
| `bshor.congress.2012.txt`   | Boris Shor's U.S. Congressional ideal estimated points, 2012       | 4.3 (practice) |
| `dwnominate.txt`            | DW-NOMINATE scores for all U.S. Congressional sessions (dta, 6MB)  | 4.3 (practice) |
| | Sessions 5--7 are not listed. | |
| `olympics.2012.txt`         | Olympics 100 m sprinters data from Markus Gessman                  | 8.0 |
| `oecd.bli.2011.txt`         | OECD Better Life Index, 2011                                       | 8.1 |
| `bartels.presvote.4812.txt` | Larry Bartel's data for a U.S. presidential election plot          | 8.2 |
| `imf.weo.2012.txt`          | IMF WEO 2012 replication data by Chris Giles                       | 8.3 (practice) |
| `icm.polls.8413.txt`        | Guardian/ICM polls, 1984-2013                                      | 9.0 |
| `beijing.aqi.2013.txt` (*)  | Beijing pollution information by the U.S. Embassy on Twitter, 2013 | 9.1 |
| `geos.tww.txt`              | GEOS episode ratings for Aaron Sorkin's _The West Wing_            | 9.2 |
| `piketty.saez.2011.txt`     | Piketty & Saez data on U.S. income inequality, 1913-2012           | 9.3 (practice) |
| `wb.projects.txt`           | World Bank aid projects in Africa (geocoded)                       | 10.1 |
| `wasserman.votes.0812.txt`  | U.S. state-level 2008-2012 vote shares, from David Wasserman       | 10.2 |
| `greys.network.txt`         | Network of characters in _Grey's Anatomy_, by Gary Weissman        | 11.0 |
| `frmps.nodes.txt`           | French MPs on Twitter in 2013 (course dataset)                     | 11.1 |
| `frmps.network.txt`         | Links between French MPs on Twitter in 2013 (course dataset)       | 11.1 |
| `assange.txt` (*)           | Speech by Julian Assange in 2012                                   | 11.2 |
| `doctorow.txt`              | Speech by Corey Doctorow in 2011                                   | 11.2 |

Also: little things are scraped from Wikipedia but are not saved, and some exercise datasets like Rheinart and Rogoff are not listed.

(*) Files marked with an asterisk required heavy preprocessing or authentification to download, and are self-contained to the course. All other files were first downloaded in their native format and then saved as plain text comma-separated values. The data preparation code appears in the course pages.

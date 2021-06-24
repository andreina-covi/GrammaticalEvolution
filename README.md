# GrammaticalEvolution
[![CI](https://github.com/andreina-covi/GrammaticalEvolution/actions/workflows/runTests.yml/badge.svg)](https://github.com/andreina-covi/GrammaticalEvolution/actions/workflows/runTests.yml)

## Installation

Installation by default

```Smalltalk
  Metacello new
 baseline:'GrammaticalEvolution';
 repository: 'github://andreina-covi/GrammaticalEvolution:master/src';
 load
```

Installation with visualization

```Smalltalk
  Metacello new
 baseline:'GrammaticalEvolution';
 repository: 'github://andreina-covi/GrammaticalEvolution:master/src';
 load: #('all')
```

----
## Example:

```Smalltalk
| a |
a := GEAssertion new seed: 245.
a  testClasses:  {RSColoredTreePaletteTest};
    targetClass: RSColoredTreePalette;
    targetSelectors: #(#allLeavesAccessibleFrom:);
    packageScope: 'Roassal3*';
    folderToExport: '/tmp'.
a run.
a.
```

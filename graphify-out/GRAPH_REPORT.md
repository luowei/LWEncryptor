# Graph Report - /Users/luowei/projects/libs/LWEncryptor  (2026-05-04)

## Corpus Check
- Corpus is ~11,683 words - fits in a single context window. You may not need a graph.

## Summary
- 96 nodes · 104 edges · 7 communities detected
- Extraction: 95% EXTRACTED · 5% INFERRED · 0% AMBIGUOUS · INFERRED: 5 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- [[_COMMUNITY_Community 0|Community 0]]
- [[_COMMUNITY_Community 1|Community 1]]
- [[_COMMUNITY_Community 2|Community 2]]
- [[_COMMUNITY_Community 3|Community 3]]
- [[_COMMUNITY_Community 4|Community 4]]
- [[_COMMUNITY_Community 5|Community 5]]
- [[_COMMUNITY_Community 6|Community 6]]

## God Nodes (most connected - your core abstractions)
1. `LWRSAEncryptor` - 43 edges
2. `LWAESEncryptor` - 15 edges
3. `LWAppDelegate` - 7 edges
4. `Data` - 7 edges
5. `NSData` - 5 edges
6. `Tests` - 4 edges
7. `LWViewController` - 3 edges
8. `NSString` - 2 edges
9. `String` - 2 edges
10. `-setUp` - 1 edges

## Surprising Connections (you probably didn't know these)
- None detected - all connections are within the same source files.

## Communities (13 total, 1 thin omitted)

### Community 0 - "Community 0"
Cohesion: 0.06
Nodes (31): LWRSAEncryptor, -decryptByPrivateKeyWithEncryptData, -decryptByPrivateKeyWithEncryptString, -decryptDataForDataprivateKey, -decryptDatapublicKey, -decryptDatarsa, -decryptEncryptDatawithRSA, -decryptStringForDataprivateKey (+23 more)

### Community 1 - "Community 1"
Cohesion: 0.16
Nodes (8): LWAESEncryptor, -decryptBase64Stringkeyiv, -decryptkeyiv, -decryptStringkeyiv, -doCiphercontextwithBinaryKeyiv, -encryptBase64Stringkeyiv, -encryptkeyiv, -sharedInstance

### Community 3 - "Community 3"
Cohesion: 0.25
Nodes (7): LWAppDelegate, -applicationDidBecomeActive, -applicationDidEnterBackground, -applicationdidFinishLaunchingWithOptions, -applicationWillEnterForeground, -applicationWillResignActive, -applicationWillTerminate

### Community 4 - "Community 4"
Cohesion: 0.25
Nodes (7): NSData, -hex, -md5, -md5String, -sha1, NSString, -md5

### Community 5 - "Community 5"
Cohesion: 0.4
Nodes (4): Tests, -setUp, -tearDown, -testExample

### Community 6 - "Community 6"
Cohesion: 0.5
Nodes (3): LWViewController, -didReceiveMemoryWarning, -viewDidLoad

## Knowledge Gaps
- **53 isolated node(s):** `-setUp`, `-tearDown`, `-testExample`, `-applicationdidFinishLaunchingWithOptions`, `-applicationWillResignActive` (+48 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **1 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `LWRSAEncryptor` connect `Community 0` to `Community 2`?**
  _High betweenness centrality (0.373) - this node is a cross-community bridge._
- **Why does `Data` connect `Community 2` to `Community 1`?**
  _High betweenness centrality (0.200) - this node is a cross-community bridge._
- **Are the 4 inferred relationships involving `Data` (e.g. with `.verify()` and `.encryptInChunks()`) actually correct?**
  _`Data` has 4 INFERRED edges - model-reasoned connections that need verification._
- **What connects `-setUp`, `-tearDown`, `-testExample` to the rest of the system?**
  _53 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Community 0` be split into smaller, more focused modules?**
  _Cohesion score 0.06 - nodes in this community are weakly interconnected._
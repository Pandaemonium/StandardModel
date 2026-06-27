# Track B cycle 27: semantic-index freshness is a research assumption

Date: 2026-06-27
Cycle: 27
Track: B - retrieval / obstruction-calculus guardrail

## Trigger

After several Lean and documentation edits, the loop attempted to refresh the Neo4j repo-document semantic index with `Scripts/lit/neo4j_doc_search.py`. The refresh timed out after five minutes.

## Named failure mode

**Semantic-index-staleness fallacy.** A later reasoning step relies on semantic search over the repo as if it includes the newest Lean/doc changes, even though the changed-file ingest has not completed successfully.

## Finite theorem target

Represent retrieval freshness as explicit metadata rather than a background assumption:

```lean
structure RetrievalFreshnessToy where
  fileChanged : Bool
  indexRefreshed : Bool
  queryReliesOnChangedFile : Bool

def SearchFreshForClaim (d : RetrievalFreshnessToy) : Prop := ...
```

Target counterexample:

```lean
theorem changedFile_unrefreshed_not_searchFresh :
    exists d,
      d.fileChanged = true /\ d.indexRefreshed = false /\
      d.queryReliesOnChangedFile = true /\ not SearchFreshForClaim d
```

## Claim boundary

Paper full-text search remains available and useful. Repo semantic search is only current after a successful changed-file ingest or a query result known not to depend on recently changed files.

/-!
# Meta.SourceTrace

Provenance metadata support for PhysicsSM declarations.

Provides structures for recording source references, license origin, convention
choices, and oracle backends associated with definitions and theorems.

Status: lightweight metadata vocabulary.  This file intentionally does not
claim that any source supports any theorem.  It only gives future provenance
notes a typed shape for source identity, role, verification status, and
convention checks.
-/

namespace PhysicsSM.Meta.SourceTrace

/-- Source reference kinds used in provenance metadata. -/
inductive SourceKind
  /-- Journal article, proceedings paper, thesis, or preprint. -/
  | paper
  /-- Textbook, monograph, or handbook. -/
  | book
  /-- External code repository or machine-readable dataset. -/
  | repo
  /-- CAS, oracle, generated fixture, or computational backend output. -/
  | oracle
  /-- Clean-room formalization from mathematical definitions, with no external
  implementation copied. -/
  | cleanroom
  deriving DecidableEq, Repr

/-- The role a source plays in a declaration or manuscript claim.

This separates "the source proves the same statement" from weaker but common
roles such as inspiration, comparison, convention, or background. -/
inductive SourceRole
  /-- The source is claimed to contain the mathematical statement, after
  statement and convention matching. -/
  | theoremSupport
  /-- The source gives a convention, normalization, sign, or terminology. -/
  | convention
  /-- The source is related work or a comparison target, not support for the
  formal statement. -/
  | comparison
  /-- The source motivated the construction, but the Lean development is
  clean-room. -/
  | inspiration
  /-- The source records data or an oracle output that must not be treated as a
  kernel proof. -/
  | computationalEvidence
  deriving DecidableEq, Repr

/-- Verification status for a source-reference edge.

`verified` means the statement and conventions have been checked for the stated
role.  It does not mean the source has been formalized. -/
inductive VerificationStatus
  /-- Source key or identifier is known, but statement/convention matching is
  still pending. -/
  | pending
  /-- Only an identifier is known locally; no canonical local source key has been
  recorded. -/
  | identifierOnly
  /-- Metadata exists, but full-text or chunk-level support is unavailable. -/
  | noFullText
  /-- Statement and convention matching have been checked for the stated role. -/
  | verified
  /-- The source was checked and should not be used for this role. -/
  | rejected
  deriving DecidableEq, Repr

/-- Claim-grade labels used by manuscript-facing provenance records.

These mirror the project prose calculus without making the metadata layer depend
on a particular manuscript file. -/
inductive ClaimGrade
  /-- Source-verified theorem or imported classical result. -/
  | T
  /-- Conditional theorem under displayed hypotheses. -/
  | TH
  /-- Machine-verified program-internal result. -/
  | M
  /-- Pre-registered conjecture or gate. -/
  | C
  /-- Background, memo, or audit-only material. -/
  | memo
  deriving DecidableEq, Repr

/-- A source reference in a local provenance record.

`key` is the preferred local key: usually a bare Zotero item key, a bibliography
key such as `Baez2002`, or a stable placeholder like `TBD-NielsenNinomiya`.
`identifier` is an optional arXiv id, DOI, ISBN, URL, or repo commit.
`locator` is an optional section, theorem, page, chunk id, or declaration name. -/
structure SourceRef where
  key : String
  kind : SourceKind
  title : Option String := none
  identifier : Option String := none
  locator : Option String := none
  status : VerificationStatus := .pending
  deriving DecidableEq, Repr

/-- A convention check attached to a provenance record.

Examples: metric signature, octonion basis, chirality convention, scalar field,
normalization, or antilinear-vs-linear real-structure behavior. -/
structure ConventionCheck where
  name : String
  status : VerificationStatus := .pending
  note : String := ""
  deriving DecidableEq, Repr

/-- A provenance record for one declaration, document section, or task artifact.

The field `target` is intentionally just a string so the same type can describe a
Lean declaration, a Markdown section, or an oracle fixture. -/
structure TraceRecord where
  target : String
  grade : Option ClaimGrade := none
  role : SourceRole
  sources : List SourceRef := []
  conventionChecks : List ConventionCheck := []
  note : String := ""
  deriving DecidableEq, Repr

namespace SourceRef

/-- A local source-key reference whose statement/convention check is still open. -/
def pendingPaper (key : String) (identifier : Option String := none)
    (title : Option String := none) : SourceRef where
  key := key
  kind := .paper
  title := title
  identifier := identifier
  status := .pending

/-- A source reference with a known identifier but no canonical local key yet. -/
def identifierOnlyPaper (placeholderKey identifier : String)
    (title : Option String := none) : SourceRef where
  key := placeholderKey
  kind := .paper
  title := title
  identifier := some identifier
  status := .identifierOnly

/-- A clean-room provenance marker for definitions or proofs that use no
external implementation text. -/
def cleanroom (key : String := "cleanroom") : SourceRef where
  key := key
  kind := .cleanroom
  status := .verified

end SourceRef

namespace ConventionCheck

/-- A pending convention check by name. -/
def pending (name : String) (note : String := "") : ConventionCheck where
  name := name
  status := .pending
  note := note

/-- A convention check recorded as complete for a local role. -/
def verified (name : String) (note : String := "") : ConventionCheck where
  name := name
  status := .verified
  note := note

end ConventionCheck

namespace TraceRecord

/-- A clean-room trace record for a local target. -/
def cleanroom (target : String) (grade : Option ClaimGrade := none)
    (note : String := "") : TraceRecord where
  target := target
  grade := grade
  role := .inspiration
  sources := [SourceRef.cleanroom]
  note := note

/-- A comparison-only trace record.  Use this when a source is background or a
classical analogue, but not a proof of the local statement. -/
def comparison (target : String) (refs : List SourceRef)
    (grade : Option ClaimGrade := none) (note : String := "") : TraceRecord where
  target := target
  grade := grade
  role := .comparison
  sources := refs
  note := note

end TraceRecord

end PhysicsSM.Meta.SourceTrace

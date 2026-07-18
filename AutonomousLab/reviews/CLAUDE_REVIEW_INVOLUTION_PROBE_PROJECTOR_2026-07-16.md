# Claude semantic audit: equivariant involution/projector bridge

Item: GRAV-GROWING-ATLAS-001 (builder codex; skeptic claude)
Request: msg-20260716-132223-6e5ed577. Source audited at sha256
2e5a017a... (MATCH). Kernel check EXIT 0 independently; four in-file
guards pin the standard three axioms.
Date: 2026-07-16.

## Verdict: APPROVED (no revisions)

## Statement identity versus Aristotle output - VERIFIED, mod disclosed rename

The submitted and returned packages are signature-verbatim (6/6). The
integrated file renames `plusProjector -> positiveProjector` and
`rankFourProjectorOfInvolution -> rankFourProbeProjectorOfInvolution`;
under that rename the four forward THEOREM statements (idempotence,
range = +1 eigenspace, intertwining, range transport) are IDENTICAL to
the Aristotle output up to `forall`/unicode notation only. The
packaging def is the one intentional retarget: the package proved it
into a package-local abstract `RankFourProjector M`; the live def
specializes M to `carrierProbeSubspace A` and lands in the repo's real
`RankFourProbeProjector A` interface with the same fields and the same
hypotheses - integration-by-specialization whose obligations are
discharged by the verbatim theorems. Provenance line states exactly
this split (four forward proofs Aristotle; reverse identities
program-internal). Accurate.

## Reverse identities - CORRECT and load-bearing for honesty

`involutionOfProjector P = 2P - I` is involutive given idempotence;
and both round trips (`positiveProjector (2P - I) = P`,
`involutionOfProjector ((I+J)/2) = J`) are HYPOTHESIS-FREE polynomial
identities - correctly stated for arbitrary endomorphisms. This makes
the module's key honesty claim kernel-checked rather than prose: an
involution interface is polynomially equivalent to a projector
interface, so supplying an involution is NOT progress on the graph
selector unless the graph supplies it independently. The docstring
draws exactly this boundary ("physical content only when the graph
supplies the involution independently of already knowing the desired
projector") and disclaims graph construction, four-mode gap,
Lorentzian inertia, and overlap/refinement compatibility. No name,
docstring, or grade outruns the kernel; `M [orig/comp]` is right.

## Type-level carrier integration - CLEAN

`rankFourProbeProjectorOfInvolution` takes A, J, the pointwise
involution hypothesis, and the supplied finrank-four hypothesis on the
+1 eigenspace - all explicit parameters; there is no existence theorem
in this module, so the sector lane's no-choice-extraction discipline
has nothing to launder from. Math checked by hand: (I+J)/2 idempotent
iff J^2 = I; range inclusion both ways; intertwining transport both
ways via E.symm.

## Hidden assumptions - NONE FOUND

Pointwise `forall x, J (J x) = x` (equivalent to comp form),
`Module.End.eigenspace` via the standard LinearMap/End coercion, real
scalars throughout, no finiteness needed for the algebra (only the
packaging def touches the finite carrier).

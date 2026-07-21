import PhysicsSM.Draft.NullEdge.DixonDiracGamma

/-!
# P2: the signature classification for quaternionic bar operators

**Goal ("signature from H").** The landed `DixonDiracGamma` shows the four
bar operators `gamma^mu` built from H-units satisfy the Clifford table with
`eta = diag(-1, +1, +1, +1)`. The MISSING half of the P2 claim is the
CLASSIFICATION: within the natural finite class of quaternionic bar
operators, Lorentz signature is FORCED - the alternatives `(4,0)` and
`(2,2)` are unreachable.

## The finite class

Bar operators `B_{u,v} d = (u * d) * v` with `u, v` ranging over the eight
Dixon H-basis elements `{1, i1, i2, i3}` and their negatives (equivalently:
the 16 unsigned pairs; signs only flip the operator sign, not its square).
`bar`, `Idix`, `i1, i2, i3` are already defined in the imported module.

## Tasks

1. **Square law**: for each unsigned pair `(u, v)`, kernel-determine
   `B_{u,v} (B_{u,v} d)` as `s(u,v) • d` with `s(u,v) in {+1, -1}` (free
   `d` statements; 16 finite cases - state the complete sign table as
   kernel theorems, batched sensibly).
2. **Anticommutation constraint**: determine which pairs of unsigned
   `(u,v)`-operators anticommute (the candidate gamma-sets must be mutually
   anticommuting). It suffices to characterize anticommutation within the
   class in whatever finite form is convenient (e.g. per-pair kernel
   checks for the pairs relevant to task 3).
3. **THE CLASSIFICATION THEOREM**: any four mutually anticommuting
   operators from the class have square-sign multiset `{-1, +1, +1, +1}`
   (up to overall negation of all four operators, which preserves squares -
   so equivalently: the multiset is NEVER `{+1,+1,+1,+1}`, `{-1,-1,+1,+1}`,
   etc.). State it in whatever finitely-checkable form is cleanest (e.g.
   enumerate the maximal mutually-anticommuting quadruples from tasks 1-2
   and check each multiset), but the final statement must quantify over the
   full class, not just exhibit one quadruple.
4. If the classification FAILS (some quadruple achieves another signature),
   exhibit it prominently - that kills the "signature forced" reading and
   is a first-class honest outcome.

Constraints: no new axioms; no n a t i v e _ d e c i d e (finite case
enumeration must go through `Finset`/`decide`-free kernel proofs or
explicit case lists); standard axiom set; free-variable statements
preferred; follow the landed proof style.
-/

namespace PhysicsSM.Draft.NullEdge.DixonSignatureClassification

-- All construction per the module docstring: TO BE BUILT by this job.

end PhysicsSM.Draft.NullEdge.DixonSignatureClassification

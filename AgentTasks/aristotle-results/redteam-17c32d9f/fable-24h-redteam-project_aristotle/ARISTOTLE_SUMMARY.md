# Summary of changes for run 400bfc21-66a7-4ac9-a192-9d78fb4f29b7
Delivered `REDTEAM_MEMO.md` at the project root: a hostile-referee (reading-for-rejection) review of all three manuscripts in `context/` (Paper A = Null-Edge area-to-Dirac-gap; Paper E = finite-CAR pair-gate dynamics; Paper F = Furey–Baez octonion SM formalization). All quotations are verbatim with line/section citations.

For each paper the memo gives the four requested items:

1. **Overclaim sentence (verbatim) + minimal fix.**
   - A: "the rest gap is the null-spinor area, with no independent mass parameter" (abstract) — the body itself concedes constant |z| "would only reparametrize an assigned Dirac mass"; fix = call it a reparametrization, not elimination of a scale.
   - E: "We assemble a machine-checked account of the interacting layer…" — flatly contradicted by §4 ("nothing in this section is claimed as kernel"); fix = "partly machine-checked, §4 spectrum still oracle-exact."
   - F: the abstract's unqualified "group of octonion algebra automorphisms … equivalent to SU(3)"; fix = insert "algebraically defined … of the explicit model" (the body's own Boundary remark).

2. **Docstring-outruns-kernel (tag broader than the finite statement).**
   - A: abstract's "Every finite statement above is checked in Lean 4" vs. its own "exact run record"/"central-node instance" parenthetical.
   - E: the `\DraftTrust` (Kernel+Eval) tag on PairMomentumBlocks — "compiled-evaluator identities … transported … on a Gaussian-rational twin," i.e. eval-trusted, transported, on a surrogate, sold as "machine-checked."
   - F: thm:su3 prose "this is a group isomorphism … not a separately formalized theorem" while the kernel object is only a MulEquiv onto a submonoid; plus abstract "every theorem kernel-checked" vs §3 "only the flagships … enforced."

3. **Weakest logical link.** A: the "derivation" collapses to the classical det P = |ψ∧φ|² renaming plus a 2×2 normal form. E: the title's "exact interacting spectrum" (§4) is entirely a promissory note. F: the "unification" thesis is admitted to be "parallel uses of a common choice, not corollaries of one master theorem," and the DVT/F₄ link is "external, not formalized."

4. **Abstract vs body.** A: convergence claim delivered (1+1 and 3+1 rate theorems), but the derived-mass headline is softened in body. E: strongest claim is explicitly retracted by §4. F: SU(3) claim substantially delivered but with two silent narrowings (algebraic-not-Lie; MulEquiv-not-group-iso).

**Highest-payoff <2h change (portfolio-wide):** make each abstract's single global verification adjective match the body's own boundary text — most urgently Paper E line 41, whose "machine-checked account of the interacting layer" directly contradicts §4. This converts the most damaging referee charge (inflated verification claims) into "scoped and auditable" at zero mathematical cost. The memo also includes a one-line severity ranking (E most reject-prone, then A, then F).

The memo is review-only (no Lean changes); it is committed and pushed to the project branch.

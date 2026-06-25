# Null-Strand Lean theorem charter template

Every physics-facing file or theorem cluster should answer these questions before proof work begins.

## Identity

- **Node ID:**
- **Lean module:**
- **Proposed declarations:**
- **Claim kind:** definition / theorem / conditional theorem / no-go / computation / conjecture
- **Formal state:**
- **Physics role:** kinematic / equivariance / ontology / dynamics / interpretation / new-physics gate

## Mathematical contract

- **State space:**
- **Primitive variables:**
- **Time model:** discrete kernel / continuous jump generator / deterministic flow / PDE / operator evolution
- **Measure or density:**
- **Operator or transition rule:**
- **Symmetry/covariance group:**
- **Exact assumptions:**
- **Exact conclusion:**
- **Dependencies by node ID:**
- **Expected proof strategy:**
- **Likely mathlib imports:**
- **Known library gap:**

## Physics boundary

- **What this theorem would establish:**
- **What it would not establish:**
- **Is a law derived or merely selected?**
- **Empirical content, if any:**
- **Failure/counterexample condition:**

## Review checklist

- [ ] Signature and normalization conventions are explicit.
- [ ] No representation firewall violation.
- [ ] Discrete-time kernels are not confused with continuous-time generators.
- [ ] Expectation statements are not promoted to pathwise statements.
- [ ] Ensemble decompositions are not promoted to unique ontologies.
- [ ] Zero-density and zero-denominator cases are explicit.
- [ ] Every conditional analytic hypothesis appears in the theorem signature.
- [ ] Public proof contains no `sorry`, `admit`, or unnamed axiom.
- [ ] `#print axioms` output is approved for capstones.
- [ ] The blueprint and manifest node are updated.

# Hostile audit: continuous even-exterior action and coordinate block stabilizer

Act as an adversarial mathematical referee. Read the two verbatim Lean modules
appended to this prompt. Do not edit or prove them. Return a severity-ranked
semantic audit.

Intended claims:

1. The trusted algebraic unit cover acts linearly on the supplied
   five-dimensional `C^2 + C^3` space, hence functorially on exterior degrees
   `0`, `2`, and `4` and on their sixteen-dimensional direct product.
2. Every one of the six trusted unit-level `Z6` covering-kernel elements acts
   identically on that even exterior module. This is kernel inclusion only.
3. Independently, a coordinate `3 x 3` unitary preserves the upper `2 x 2`
   matrix block under conjugation iff it is `2+1` block diagonal, with a
   determinant factorization, nonidentity stabilizer, and mixing control.
4. We do NOT claim exactness of the exterior-action kernel, a Jordan-derived
   `2+3` split, a Furey intertwiner, intrinsic `F4` transitivity, or a
   topological/Lie quotient theorem.

Audit for vacuity, hollow telescoping, false shape, docstring inflation,
incorrect exterior degree/chirality, wrong multiplication order, dimension
numerology, hidden determinant assumptions, weak controls, and any accidental
conflation of `UnitCoveringTriple`, `SMCoveringTriple`, and the true
`SMProductCoveringTriple`.

Output:

1. PASS / PASS WITH REQUIRED SCOPE EDITS / FAIL.
2. HIGH/MEDIUM/LOW findings with exact declaration names.
3. Strongest manuscript sentence earned by each module.
4. Forbidden statements.
5. Smallest theorem needed for exact product-cover action-kernel `Z6`.

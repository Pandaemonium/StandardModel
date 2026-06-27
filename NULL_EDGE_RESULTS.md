# Null-edge program: key results

**High-level summary, 2026-06-27.**

This document records the most important things the null-edge mass program has
actually shown, separated by trust level. It is a map, not a full theorem list.
For detail see [`Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`](Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md),
the P1 manuscript [`Sources/Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md`](Sources/Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md),
and [`docs/NULLSTRAND.md`](docs/NULLSTRAND.md).

Claim labels are used throughout, in decreasing strength: **finite identity**
(kernel-checked algebra), **reconstruction** (a known mechanism recovered from
null-edge primitives, inputs still free), **structural theorem** (a qualitative
feature forced by stated algebraic inputs), **prediction** (a normally-free EFT
parameter fixed or restricted). The program has **no predictions yet**.

---

## 1. The thesis in one line

> Primitive spacetime transport can be organized as null-edge transport, and
> effective mass appears as a canonical quadratic obstruction to remaining a
> single free gapless null mode.

The project should now be read as an **obstruction-geometry program**, not only
as "mass from null-edge spread." The finite Plucker theorem is the trusted core,
but the broader target is to classify when a one-beam, one-branch, one-orbit, or
one-canonical-mode description fails.

The deliberately *non*-claim: not all mass is literally one Plucker-spread
formula. Different sectors (Yukawa, electroweak, QCD, Higgs, Gate C branch
release) realize the same *obstruction pattern* through different canonical
maps: finite rank/mixedness defects, stiffness/Hessian directions, branch-line
selection failures, and forbidden internal maps.

---

## 2. The strongest result: the finite Plucker-mass theorem (TRUSTED)

This is the solid core. It is kernel-checked under `leanprover/lean4:v4.28.0`,
with no `s o r r y`, in `PhysicsSM.Spinor.PluckerMass` and
`PhysicsSM.Spinor.TwistorPluckerMass`.

A massless ("null") degree of freedom is a two-component Weyl spinor `psi`; its
contribution to momentum is the rank-one Hermitian bispinor `psi psi^dagger`. A
visible particle-like system is a finite *bundle* of these, with total momentum
`sum_i psi_i psi_i^dagger`. The central identity:

```text
det( sum_i psi_i psi_i^dagger ) = sum_{i<j} | psi_i wedge psi_j |^2 .
```

The left side is invariant mass squared; the right side is the total pairwise
Plucker spread of the null directions. Established (all trusted unless noted):

- **A single null edge is massless** (`det_rankOneHermitian_eq_zero`).
- **Mass = total pairwise spread** for any finite bundle
  (`fin_bundle_plucker_mass_identity`).
- **Mass is a genuine nonnegative real** `m^2 >= 0`
  (`fin_bundle_det_im_eq_zero`, `fin_bundle_det_re_nonneg`).
- **Exact massless criterion**: `m^2 = 0` iff all null directions are
  projectively collinear -- one common beam
  (`fin_bundle_mass_zero_iff_common_direction`).
- **Twistor-chart matching** with explicit, non-drifting normalization
  conventions (`multi_twistor_momentum_det_eq_pairwiseMass`).

Kernel-clean but still *draft* (need convention/semantic review before
promotion): **`SL(2,C)`/Lorentz invariance** of the determinant mass, the
**celestial moment form** `m^2 = (E^2 - |C|^2)/4` (energy monopole minus
momentum dipole), and the **static Dirac square root** that squares back to this
mass (the seam to the P2 operator program).

**Reading.** This makes the old "trapped, disagreeing light" / "mass without
mass" intuition exact and machine-checked: a finite bundle of null momenta has
invariant mass exactly to the extent its directions fail to align. Equivalently,
with `P = sum_i psi_i psi_i^dagger` and `rho = P / Tr(P)` after a chosen visible
normalization, the massless locus is the pure/projectively rank-one locus and
mass is the visible null-direction impurity. The invariant theorem remains
`det(P) = m^2`; normalized mixedness is the observer-conditioned `m/E` reading.
It is finite kinematics -- not a continuum Dirac limit, not a particle spectrum,
not QCD or Higgs dynamics.

---

## 3. The canonical-obstruction dictionary (RECONSTRUCTION / STRUCTURAL)

The same "quadratic obstruction to staying one free null mode" reappears across
mass mechanisms. Status per sector:

| Mechanism | Canonical obstruction | Status |
| --- | --- | --- |
| Finite null bundle | Plucker spread `(psi_i wedge psi_j)` | **Finite identity** (Section 2). |
| Dirac/Yukawa fermion | mass map `M : E_R -> E_L` | Reconstruction once `M` is given; predictive only if `M` is constrained. |
| W/Z bosons | `X |-> X H_0` | **Structural theorem** given SM electroweak group, Higgs rep, vacuum section (orbit-stiffness rank / stabilizer theorem). |
| Photon | `X |-> 0` | Stabilizer direction giving unbroken `u(1)_em`. |
| Higgs boson | radial Hessian of the potential at vacuum | Scalar-potential reconstruction. |
| QCD/hadron mass | no clean finite obstruction yet | Plucker gives invariant accounting once momenta are given; confinement is external. |

The word **canonical** is load-bearing: a map only counts if it is forced by
geometry, representation theory, gauge covariance, or finite algebra. A map
chosen *after* the mass is known is just reparametrization.

The common template is:

```text
zero locus / moduli locus
+ canonical obstruction section or map
+ quadratic norm, determinant, Hessian, or gap
= mass-like stiffness or release criterion
```

This is the intended unifying language. It lets P1 stay a finite identity while
allowing Gate C, Gate H, electroweak stiffness, and neutrino map choices to have
their own honest mechanisms.

---

## 4. The finite super-Dirac square (DRAFT spine)

The P2 operator program targets a finite dual-soldered Dirac operator
`D = i D_N + Gamma_s Phi_H` with the trusted sign convention

```text
D^2 = -K_null - C_diamond - T_frame + Phi_H^2
      - i Gamma_s sum_a C_a [nabla_a, Phi_H] .
```

Key established discipline (Gate A/B, strong draft):

- The Higgs/Yukawa block `Phi_H` is `chi_E`-odd internally and `Gamma_s`-even,
  which forces the **`+Phi_H^2`** sign in the square.
- The kinetic (Plucker/null-spread) side and the zero-order `Phi_H^2` mass side
  are matched by an **on-shell condition**, not added as two independent masses.
- Spacetime chirality `Gamma_s`, internal grading `chi_E`, and form degree are
  kept strictly separate.

---

## 5. The sharply isolated blocker: Gate C

The honest hard problem. The bare retarded null-edge symbol `D_+` does **not**
release as a physical chiral operator. What is now *proved* (not merely
suspected):

- **Bare alignment fails** (C21): the four-component symbol does not force
  aligned chirality. Each nonzero null branch carries a two-dimensional,
  chirality-balanced kernel (one left + one right Weyl line).
- **The determinant-zero locus is larger than the modeled branches**: there are
  off-branch zeros (e.g. `q_star`) and a cyclotomic/S4 orbit of extra zeros
  (C43/C44, C64, C66). A naive `g5` split does not control them.
- **Scalar Wilson lifting cannot release Gate C** (C88, taste no-go): a term
  that is scalar on the origin corner and vanishes quadratically at the origin
  cannot turn the balanced origin kernel into a single chirality, and cannot
  separate an unwanted branch germ reaching the origin.

This produced a clean **C0 / C1 split**:

- **Gate C0 (external species health)** -- plausibly reachable. An
  anti-Hermitian operator plus a positive scalar Wilson mass has a quantitative
  norm lower bound and no kernel (C85/C86, abstract linear algebra, kernel-clean
  draft). On the real torus `W(q) = sum_a (1 - cos q_a)` vanishes only at the
  origin, so it gaps every non-origin determinant zero -- including unknown ones
  -- *without* classifying the full locus.
- **Gate C1 (physical chiral release)** -- still open, and **mandatory** for the
  Standard-Model-facing claim. Because the total chiral index factorizes over
  `H_N tensor H_F`, a chiral internal sector cannot rescue a balanced external
  origin (C87). Origin polarization needs a genuine spinor-line construction
  (projected Weyl / domain-wall / overlap / branch involution `T_br`), not a
  taste-only one.

A hard ghost rule governs any release: **no gauge-charged branch may be removed
solely by a propagator zero** (Golterman-Shamir) -- removal must come from a true
inverse-propagator mass gap.

Current posture: the bare operator is labeled **FATAL-FOR-NAIVE-FLAT, not fatal
for the program**. Release, if it happens, is for a specified regulated/projected
`D_phys`, not for `D_+`.

Pro Gate C refinement (2026-06-27): treat C0 as the clean species-health theorem
and C1 as a separate **release datum** problem. If the doubled external symbol is
anti-Hermitian and the scalar Wilson weight satisfies `W(q) >= 0`, then
`A(q) + r W(q) I` has a quantitative gap bounded by `r W(q)`; this can gap
non-origin real-torus zeros without classifying the full branch locus. That is
C0 evidence only. C1 requires additional data:

```text
(D_gap, Pi_phys, D_phys, Gamma_lat, physical/Krein data)
```

with a one-Weyl-line origin sector, true inverse-propagator gaps on mirror or
unwanted branch components, locality or controlled quasi-locality, ghost-zero
safety, anomaly accounting, and positive physical residues. Direct unprojected
overlap on the full bare `D_+` is now a risk to test, not a default route: if an
unwanted zero branch germ reaches the origin and crosses the shifted Wilson mass
shell, the overlap sign kernel becomes singular. The null-edge-native C1 route
is therefore either a genuine branch classifier/projector (`T_br` or `Pi_br`) or
a controlled domain-wall/projected-overlap construction after that branch split.

---

## 6. Internal algebra: the Furey/Baez bridge (Gate H, PROMISING SUPPORT)

The internal finite half (charges, gauge data, anomaly inheritance, `chi_E`
grading, legal Higgs/Yukawa bookkeeping) is supplied by Furey/Baez/Gresnigt/DVT
division-algebra structure, used through the **associative** left-action algebra
of complex-octonion left multiplications -- never raw octonion products as if
associative.

- Clear product architecture: `H_total = H_null tensor H_Furey`,
  `D = i D_N tensor 1 + Gamma_s tensor Phi_H`.
- The best near-term **prediction-grade** target identified is a
  *forbidden-operator / codimension* theorem: every legal finite Dirac/Higgs
  operator has exactly the SM block form (arbitrary Yukawa matrices, optional
  `M_R`), with **no** leptoquark, diquark, proton-decay, wrong-hypercharge, or
  colored-Higgs blocks. This would be genuinely structural if the forbidden
  blocks vanish from the axioms rather than by hand.

Firm guardrail: **Gate H does not release Gate C.** Internal richness cannot fix
the external branch locus.

---

## 7. What is NOT yet shown

To prevent overclaim, the program explicitly does **not** have:

- a released Gate C physical chiral (C1) branch theorem;
- a continuum Lorentzian/DEC convergence theorem for the null-edge operator;
- any derived Yukawa value, gauge coupling, `Lambda_QCD`, or generation number;
- a numerical mass-spectrum prediction;
- a neutrino mechanism (Dirac vs Majorana, seesaw, mixing) -- treated only as a
  stress test.

Prediction discipline:

```text
first target: absence / forbidden-operator / codimension theorems;
next target: rank, texture, or map-choice constraints;
later target: numerical mass values, only after a constrained finite-to-EFT map.
```

This means the first genuine prediction-grade output may be a structural
exclusion, not a number.

---

## 8. Bottom line

The program currently has: a **trusted finite kinematic mass theorem**; a
coherent canonical-obstruction language; a draft finite super-Dirac square; a
gauge-invariant electroweak orbit-stiffness reconstruction; a promising internal
Furey/Baez algebra bridge; and a **sharply isolated Gate C blocker** with a
clean C0/C1 split.

The three next decisive successes would be: (1) a projected/split Gate C1 release
with ghost and Krein safety; (2) a Furey/Baez codimension theorem showing a real
internal-sector constraint; (3) a DEC / connection-Laplacian continuum scaffold
for the null-edge operator.

Even if no prediction ever appears, the trusted P1 theorem plus a formalized
reconstruction of known mass mechanisms is a coherent, defensible result on its
own.

## 9. Lateral-analysis updates (2026-06-27)

- **Mixedness reformulation (finite + observer-conditioned):**
  For any finite bundle define `P = sum_i psi_i psi_i^\dagger` and `rho = P / Tr(P)` in a chosen visible sector.
  The trusted identity remains `det P = m^2`, while `det rho = (m/(2E_u))^2` is an observer-conditioned impurity rate in the chosen timelike frame.
  Massless is equivalent to projective rank-one (`rho` pure); mass is finite impurity of the resolved visible null sector. This is strongest when phrased as a finite “resolution-observer vs kinematic-observer” split.

- **Plucker hierarchy lens:**
  The current theorem is the `k=2` member `sum_{i<j}|psi_i \wedge psi_j|^2`.
  A natural program extension is the full Cauchy–Binet ladder `e_k(Psi Psi^\dagger)` / higher exterior-power obstruction, with physical meaning as higher-mode rank bounds and multibranch structure diagnostics.

- **Gate C topology-first framing:**
  Keep `Z = { q : det D_+(q) = 0 }` as a first-class branch object.
  Gate C is not a scalar-coefficient tweak target alone; it is a branch-line/sheet selection and kernel-sheaf problem with nodal-control, projection, branch involution, gap, and ghost-zero safety clauses made explicit.

- **Prediction-priority adjustment:**
  Before mass-value predictions, prioritize prediction-grade structural outputs:
  (i) forbidden-operator and codimension theorems (no leptoquark/diquark/proton-decay/colored-Higgs legal blocks),
  (ii) rank-defect constraints, and
  (iii) C0/C1 split discharge with ghost-safe, Krein-positive physical sector data.

- **Neutrino as sharp stress test:**
  Keep neutrinos as the most immediate map-choice stress test, not a solved mechanism.
  Treat Dirac/Majorana/seesaw as branchable options constrained by canonical obstruction and projection architecture.

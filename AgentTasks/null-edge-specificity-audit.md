# Null-edge specificity audit for P1.5

**No-build audit deliverable. Generated 2026-06-26.**

This is job G4 from the working plan (`Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`,
Section 21.6): a null-edge specificity audit for every P1.5 theorem target. No
Lean, Lake, pre-commit, or build/check command was run. All statements about
theorem content are read from the program's own source documents
(`Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` Sections 17-21,
`docs/CONVENTIONS.md`, and `AgentTasks/null-edge-unified-mass-proof-chain.md`)
and must be re-verified against the live repo before relying on them.

The single question this audit answers for each target:

```text
What, in this theorem, actually uses null edges?
```

A theorem "uses null edges" only if the null structure (light-cone direction
pairing `ell_a`, dual-covector soldering `alpha^a`, or the Lorentzian
inverse-Gram weights `G^{ab}`) is load-bearing in the proof, not merely in the
surrounding prose interpretation.

## Classification scheme

The four classes requested, made operational:

```text
null-essential
  The null structure is load-bearing in the statement/proof. Remove the null
  data and the theorem either becomes false, vacuous, or a different (weaker)
  statement. This is where the null substrate does mathematical work.

graph-general but compatible
  The theorem is true on any decorated graph / any finite-dimensional carrier.
  Nullness is a faithful and natural interpretation of the indices, but the
  proof never uses it. Compatible with the null program, not evidence for it.

standard reconstruction
  The theorem is ordinary linear algebra / representation theory / calculus,
  independent of any graph or spacetime substrate at all. It reconstructs a
  known mechanism; the null substrate is irrelevant to the proof.

requires dual-soldered/scalar kinetic theorem to become null-specific
  Currently graph-general or standard, but is explicitly slated to be tied to
  the null substrate by an external theorem (the dual-soldered commutator/symbol
  theorem T13/B1, the finite square decomposition B4, or the scalar/gauge null
  kinetic reconstruction T-D/B3). Without that bridge it is null labels only.
```

These classes overlap in practice: a target can be "graph-general but
compatible" *now* and simultaneously "requires the scalar-kinetic theorem to
become null-specific" as its upgrade path. The table records the primary class
plus the upgrade dependency.

## Classification table

```text
P1.5 target                         primary class                         what uses null edges (load-bearing?)                                  upgrade dependency
-----------------------------------  ------------------------------------  --------------------------------------------------------------------  ------------------------------------------------
A. Yukawa checkerboard square        graph-general but compatible          The L/R channels are read as the two light-cone null directions       T13/B1 dual-soldered symbol: identify
   (T5; +T6 singular values)                                               (nabla_+, nabla_-). Natural but NOT used: proof is finite linear      nabla_+/- with c(alpha^+/-) nabla_{ell_+/-};
                                                                           algebra (K_L = M M^dagger, K_R = M^dagger M; equal positive spectra). then the square is genuinely null-supported.

B. Abelian Higgs link stiffness      graph-general but compatible          Nothing. Plan states explicitly (17.3 guardrail, 18.7) it is "not       T-D/B3 scalar/gauge null kinetic
   (T8)                              (closest to ordinary lattice          null-specific by itself"; the exact identity S_H = v^2 sum |w_e-1|^2    reconstruction on a null-tetrad graph
                                      gauge-Higgs theory)                  is gauge-Higgs on any graph. This is the lattice-gauge-theory twin.    (Lorentzian inverse-Gram weights G^{ab}).

C. Electroweak stabilizer ker/rank   standard reconstruction               Nothing spacetime-side. This is internal-fiber representation theory   None on the null side. Null-independent by
   (T9; +T10 coefficients)           (structural theorem given SM inputs)  on C^2: ker B_EW = u(1)_em, rank q = 3, B_EW(X) = X H_0. The graph     construction; it is the internal-grading
                                                                           and null edges play no role in the kernel/rank computation.           sector, orthogonal to the null substrate.

D. Scalar/gauge null kinetic         null-essential                        The Lorentzian inverse-Gram reconstruction                            This IS the bridge theorem. Status: target,
   reconstruction (T-D / B3)         (the load-bearing target)             g^{-1}(xi,eta) = sum_{a,b} G^{ab} xi(ell_a) eta(ell_b), with the       not yet proved. Depends on B0 NullSolderFrame
                                                                           cross terms, is where null edges do real work. A bare positive sum    and B1/B3 (tetrahedral inverse-Gram).
                                                                           sum_a |nabla_a^A H|^2 is Euclidean/graph-like; the cross terms are not.

E. Higgs radial Hessian appendix     standard reconstruction               Nothing. Vertex-potential physics (17.8): m_h^2 = 2 lambda v^2 is a    None. Explicitly NOT a null-edge transport
   (T12)                             (one-variable calculus)               one-variable Taylor/Hessian of V at the vacuum. No graph, no null.     theorem; appendix / boxed example only.

F. Neutrino / seesaw appendix        standard reconstruction               Nothing. Takagi factorization (complex-symmetric) + Schur complement   None on the null side. Inherits A's null
   (T7)                              (linear algebra; stress test)         M_light ~ -m_D M_R^{-1} m_D^T. Pure linear algebra; squared masses     compatibility only through M^dagger M; the
                                                                           still from M^dagger M. Stress test, not evidence (17.8).               seesaw block itself is substrate-free.
```

## Per-target notes

### A. Yukawa checkerboard square (T5, with T6 rectangular singular values)

What uses null edges: the *interpretation* identifies the left- and right-moving
channels with the two light-cone null directions, and the chirality flip `M`
with the Higgs/Yukawa block bridging null Weyl channels. This is the most
null-natural of the reconstruction theorems, because 1+1 light-cone coordinates
are genuinely null and the "checkerboard" is the causal-diamond bipartition.

What does not: the proof. The conclusions `K_L psi_L = M M^dagger psi_L`,
`K_R psi_R = M^dagger M psi_R`, and `spec_{>0}(M M^dagger) = spec_{>0}(M^dagger M)`
are finite linear algebra over any two finite-dimensional inner-product spaces
with commuting difference operators. Nothing in the proof needs `nabla_+`,
`nabla_-` to be null rather than any two commuting operators. Claim label in the
ledger is reconstruction, consistent with this.

Upgrade path: T13/B1, the dual-soldered commutator/symbol theorem, which forces
`nabla_pm = c(alpha^pm) nabla_{ell_pm}` on an actual null frame. Only then is the
checkerboard square supported on null edges as a theorem and not as a reading.

### B. Abelian Higgs link stiffness (T8)

This is the target the program itself flags as the lattice-gauge-theory twin.
The exact theorem `S_H = v^2 sum_e |w_e - 1|^2` with gauge-invariant mismatch
`w_e = sigma_{s(e)}^{-1} U_e sigma_{t(e)}`, plus gauge invariance and the
small-holonomy mass expansion, is exactly finite lattice gauge-Higgs theory on
an arbitrary graph. The Working Plan says so directly:

- 17.3 Theorem B guardrail: "this theorem is not null-specific by itself. It
  becomes null-edge-relevant only when the same graph is a null-tetrad graph and
  the scalar/gauge terms are tied to null-supported transport."
- 18.7: "the Abelian Higgs link theorem is close to ordinary lattice
  gauge-Higgs theory by itself."

Upgrade path: T-D/B3, scalar/gauge null kinetic reconstruction, applied with the
graph being a null-tetrad graph and the link sum replaced by the Lorentzian
inverse-Gram-weighted form.

### C. Electroweak stabilizer kernel/rank (T9, with T10 coefficients)

This target does not touch the spacetime substrate at all. `ker B_EW = u(1)_em`
and `rank q = 3` (and the T10 coefficients `m_W = g v/2`, `m_Z = sqrt(g^2+g'^2) v/2`,
`m_gamma = 0`) are computed entirely inside the internal fiber `C^2` from the SM
group, Higgs representation, and vacuum section. It is a structural theorem
*given SM inputs* and is null-independent: removing the null substrate leaves the
theorem unchanged. It lives in the internal-grading (`chi_E`) sector, which the
conventions deliberately keep separate from spacetime chirality `Gamma_s`. It is
strong and worth proving, but it is not evidence for the null substrate.

### D. Scalar/gauge null kinetic reconstruction (Theorem D / B3)

This is the only P1.5 target classified null-essential, and the plan treats it as
mandatory rather than optional (19.4 title: "Null scalar kinetic reconstruction
is essential, not optional"; 20.4 B3: "mandatory for Higgs/W/Z claims to be
genuinely null-edge rather than graph-Higgs with null labels"). The load-bearing
content is the Lorentzian inverse-Gram reconstruction

```text
g^{-1}(xi, eta) = sum_{a,b} G^{ab} xi(ell_a) eta(ell_b),   G^{ab} = g^{-1}(alpha^a, alpha^b)
```

and its application `g^{-1}(D H, D H) ~ sum_{a,b} G^{ab} <nabla_a^A H, nabla_b^A H>`.
The cross terms (`a != b`) and the indefinite signature of `G^{ab}` are the
point: a positive diagonal sum `sum_a |nabla_a^A H|^2` is Euclidean/graph-like,
so the null substrate would be doing no work; the off-diagonal Lorentzian weights
are what make scalar/gauge kinetics genuinely null-supported.

Status caveat: this is a *target*, not a proved theorem. It depends on the B0
`NullSolderFrame` packaging and the B1/B3 tetrahedral inverse-Gram calculation
(21.3), and must be re-audited against B1/B3 before promotion (21.3 integration
note). Until it is proved, the null-essential slot for P1.5 is *claimed but not
yet discharged*.

### E. Higgs radial Hessian appendix (T12)

`V(H) = lambda (H^dagger H - v^2/2)^2` with `H = (0, (v+h)/sqrt 2)` gives
`m_h^2 = 2 lambda v^2` as a one-variable Hessian. The plan (17.8) is explicit:
"it is vertex-potential physics rather than null-edge transport. Treat it as an
appendix or boxed example." No graph, no edge, no null direction appears. Pure
standard reconstruction (a calculus fact about the scalar potential).

### F. Neutrino / seesaw appendix (T7)

Takagi factorization of a complex-symmetric Majorana matrix and the Schur
complement `M_light ~ -m_D M_R^{-1} m_D^T` are standard linear algebra. Squared
masses still come from `M^dagger M`, so any null compatibility is inherited from
target A and is not intrinsic. The plan treats neutrinos as a "stress test, not
evidence" (17.8) and warns against implying sterile neutrinos or a Dirac-vs-
Majorana choice. Standard reconstruction; null-independent.

## Referee-facing answer: "Is this just lattice gauge theory with null labels?"

Honest answer, consistent with 17.11, 18.7, and 18.8:

> At the P1.5 stage, partly yes, and we say so. Taken individually, four of the
> six P1.5 targets are not null-specific. The Abelian Higgs link-stiffness
> identity is ordinary finite lattice gauge-Higgs theory on an arbitrary graph.
> The electroweak stabilizer kernel/rank theorem and the Higgs radial Hessian
> are internal-fiber representation theory and one-variable calculus, with no
> spacetime substrate at all. The seesaw appendix is standard linear algebra
> offered as a stress test. The Yukawa checkerboard square has a genuinely
> null-natural reading (left/right movers as the two light-cone directions), but
> its proof is finite linear algebra that any commuting pair of operators would
> satisfy.
>
> What is *not* lattice gauge theory with null labels is the scalar/gauge null
> kinetic reconstruction theorem: the claim that scalar and gauge kinetic terms
> are recovered from null-edge derivatives weighted by the Lorentzian
> inverse-Gram data `G^{ab} = g^{-1}(alpha^a, alpha^b)`, cross terms included. A
> positive diagonal sum over edges is Euclidean and would indeed be lattice
> gauge theory; the indefinite inverse-Gram quadrature with dual-covector
> soldering is where the null substrate does mathematical work. That theorem,
> together with the P2 dual-soldered commutator/symbol theorem, the finite
> square decomposition, and a determinant-level no-doubling branch count, is what
> separates the program from a relabelled lattice model.
>
> So: the P1.5 reconstruction theorems are a disciplined, gauge-invariant
> rewriting of standard mass mechanisms organized so that primitive spacetime
> transport stays null. They are not advertised as predictions. The null-edge
> substrate earns its keep only once the scalar/gauge kinetic reconstruction and
> the dual-soldered square are proved; until then the correct label is null-edge
> reconstruction, not a new mass theory.

Phrases to keep (from 18.8): "reconstruction", "representation", "structural
theorem"; "mass as quadratic obstruction by a canonical B". Phrases to avoid:
"we explain the origin of all mass", "predicts/derives" for any still-free input,
and any claim that the link-stiffness theorem alone is novel.

## Which theorem(s) make the null-edge substrate mathematically essential

Within the P1.5 package, exactly one target is null-essential:

```text
Scalar/gauge null kinetic reconstruction (Theorem D / B3):
  g^{-1}(xi, eta) = sum_{a,b} G^{ab} xi(ell_a) eta(ell_b)
  g^{-1}(D H, D H) ~ sum_{a,b} G^{ab} <nabla_a^A H, nabla_b^A H>
```

and it is currently a target, not a proved theorem.

The full case for "null edges do real work beyond notation" is not closed inside
P1.5; it is carried by the P2 package that B3 feeds into:

```text
T13 / B1  dual-soldered commutator/symbol theorem  ([D_h, M_f] -> c(df), c(alpha^a) not c(ell_a^flat))
T-D / B3  scalar/gauge null kinetic reconstruction (Lorentzian inverse-Gram quadrature)
B4        finite super-Dirac square decomposition  (D_N^2 = K_h + C_diamond + T_frame)
Gate C    determinant-level no-doubling branch count (det c(p(q)) = 0, not coefficient-zero)
```

If and only if these are discharged with audited signs does the null substrate
become mathematically essential rather than a faithful relabelling. The other
P1.5 targets (A Yukawa, B Abelian Higgs, C electroweak, E Higgs Hessian,
F seesaw) remain valuable reconstruction/structural theorems but do not, by
themselves, make the null substrate essential.

## Safe wording for P1.5

Use this paragraph (or a trimmed version) in the P1.5 note and its abstract:

> P1.5 collects finite toy theorems that reconstruct known mass mechanisms as
> quadratic obstructions inside a null-edge architecture. The Yukawa checkerboard
> square reconstructs fermion mass as a chirality-flip gap between null Weyl
> channels; the Abelian Higgs link-stiffness identity is an exact gauge-invariant
> stiffness theorem; the electroweak stabilizer theorem fixes the photon/W/Z
> kernel-rank split given the Standard Model inputs; the Higgs radial Hessian and
> the seesaw block are appendix-level standard results. We label these
> reconstruction and structural theorems, not predictions. We state plainly that,
> taken individually, the link-stiffness theorem is finite lattice gauge-Higgs
> theory, the electroweak and Higgs results are internal/representation-theoretic,
> and the Yukawa and seesaw results are finite linear algebra; the null reading
> is faithful but is not load-bearing in their proofs. The null-edge substrate
> becomes mathematically essential through the scalar/gauge null kinetic
> reconstruction theorem -- the Lorentzian inverse-Gram quadrature of null-edge
> derivatives -- together with the P2 dual-soldered commutator/symbol theorem,
> the finite super-Dirac square, and a determinant-level no-doubling branch
> count. Those are the theorems where null edges do work beyond notation, and we
> do not claim the substrate is essential until they are proved.

Wording rules to enforce in the P1.5 text (from `docs/CONVENTIONS.md` and 18.8):

- Do not call the Abelian Higgs link-stiffness theorem null-specific without the
  scalar-kinetic theorem; state the guardrail in the same paragraph.
- Do not present photon masslessness or the rank-three split as a prediction; it
  is structural given the SM group, Higgs representation, and vacuum section.
- Do not use "spectral gap" as the umbrella; use "quadratic obstruction by a
  canonical B". Reserve "spectral gap" for the Yukawa square and the Higgs
  Hessian, where an operator/Hessian spectrum is actually present.
- Keep fermion mass (`Phi_H^2`) and W/Z mass (`|nabla^A H|^2` / link stiffness)
  in separate blocks; never add Plucker mass and `Phi_H^2` as two sources.
- Use gauge-invariant / FMS composite language for physical W/Z excitations; do
  not assert a local gauge redundancy "breaks" as an observable fact.
- Keep QCD out of P1.5 theorem claims: "QCD supplies confinement and dynamics;
  Plucker supplies invariant accounting."

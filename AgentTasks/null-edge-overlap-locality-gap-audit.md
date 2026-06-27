# Overlap / Ginsparg–Wilson locality and gap audit for the null-edge flavored-mass kernel

Date: 2026-06-27.

Task: `AgentTasks/null-edge-wave18-c78-overlap-locality-gap-audit-aristotle-2026-06-27.md` (C78).
Kind: no-build audit (report-only).

Context:

- `AgentTasks/context-packs/gate-c-flavored-mass-overlap-20260627-065620.md`
- `AgentTasks/null-edge-wave18-flavored-mass-overlap-analysis-2026-06-27.md`
- `AgentTasks/null-edge-wave17-submissions-2026-06-27.md`

Repo anchors used (verify against the live tree before relying on any):

- `PhysicsSM/Draft/NullEdgeFlavoredChirality.lean` — flavored chirality `Γ_f = Γ_s · T`, taste involution, naive/flavored index witnesses.
- `PhysicsSM/Draft/NullEdgeGateCReleaseCriterion.lean` — operator-forced branch signs `ε_ρ`, C19 release criterion.
- `PhysicsSM/Draft/NullEdgeBranchKreinSignatures.lean` — branch projectors `P_a`, branch chirality, branch Krein signature `tr(J P_a)`.
- `PhysicsSM/Draft/NullEdgeKreinPositiveReleaseCriterion.lean` — physical-sector projector `Pphys`, `KreinPositiveSector`.
- `PhysicsSM/Draft/NullEdgeKreinLockOrigin.lean` — Krein-lock no-go and fundamental-symmetry characterization.
- `PhysicsSM/Draft/NullEdgeSuperDiracKreinCore.lean` — `IsKreinSelfAdjoint`, mass-shell symmetry `J = m^{-1} D`.
- `PhysicsSM/Draft/NullEdgeMassiveBranchLifting.lean` — does a constant mass block lift the determinant zeros?
- `PhysicsSM/Draft/NullEdgeNodalSetExhaustion.lean` — the certified nodal components do NOT exhaust the zero locus.
- `PhysicsSM/Draft/NullEdgeGateCGhostZeroSafety.lean` — Golterman–Shamir ghost-zero hazard checklist.
- `PhysicsSM/Draft/NullEdgeP9RetardedGreenSeries.lean` — finite nilpotent retarded Neumann series (finite causal-reach surrogate).
- `PhysicsSM/Draft/NullEdgeD0PositiveProxy.lean` — staged positive (Euclidean) proxy contract preceding any Lorentzian/Krein continuum claim.

This report is an audit, not a proof. Every theorem name above is a pointer to be re-checked. The purpose is to fix the *exact* analytic assumptions that must be discharged — and in which order — before an overlap or Ginsparg–Wilson (GW) physical operator built from the null-edge flavored-mass kernel may be called *local* and *physically meaningful*. It deliberately does **not** propose a continuum locality theorem as the next Lean target (see §7 scope guardrail).

---

## 0. Summary verdict

The overlap / GW playbook gives a clean, standard recipe in the *positive, Hermitian, Euclidean, infinite-volume* setting:

```text
gap of the Hermitian kernel H(m)  ==>  sign(H) is smooth in the symbol
                                  ==>  the overlap operator D_ov = 1 + Γ sign(H) is exponentially local
                                  ==>  D_ov satisfies the Ginsparg–Wilson relation
                                  ==>  modified chirality, exact index, no doublers.
```

For the null-edge kernel **none of the four implication arrows is currently licensed**, because the null-edge object is built from a *Lorentzian, retarded, dual-soldered, Krein-indefinite* symbol, not a positive Euclidean Hermitian one. The required preconditions are, in dependency order:

1. **A Hermitian gap.** There is no `sign(H)` without a self-adjoint `H` with a spectral gap away from `0`. The null-edge kernel as built is *not* self-adjoint on a positive-definite Hilbert space; it is at best `J`-self-adjoint on a Krein space (`IsKreinSelfAdjoint`, `NullEdgeSuperDiracKreinCore`). A Krein-self-adjoint operator can have **complex spectrum**, so `sign` may not even be definable.
2. **A finite-volume vs infinite-volume distinction.** A finite torus always has a discrete spectrum, so "gap" is generic but volume-dependent and says nothing about locality. Locality is an *infinite-volume / continuum-symbol* statement about decay of the position-space kernel, and requires a gap **uniform in volume** plus a uniform lower bound `|H(q)| ≥ μ > 0` over the whole Brillouin zone.
3. **A genuine locality (kernel-decay) condition** for the projected/overlap operator, which is *strictly stronger* than the finite index identities already proven, and which is exactly what the existing nodal-set exhaustion failure (`NullEdgeNodalSetExhaustion`) and ghost-zero hazard (`NullEdgeGateCGhostZeroSafety`) put in doubt.
4. A **Krein/retarded re-statement** of all three, because the Euclidean Hermitian theorems do **not** transfer: the relevant positivity is positivity of a Krein form on a *physical sector*, not positivity of a Hilbert inner product.

The recommended near-term Lean target (§5) is a **finite spectral-gap / Krein-positive-sector proxy theorem in a positive Euclidean reduction**, with the analytic continuum assumptions itemized as explicit hypotheses (§4, §6), not a continuum locality theorem.

---

## 1. The Hermitian-kernel gap condition needed for `sign(H)`

### 1.1 Standard overlap construction (the comparison baseline)

The Neuberger overlap operator is
```text
D_ov = 1 + Γ5 · sign(H_W),     H_W = Γ5 (D_W − m),
```
where `D_W` is a Wilson(-type) Dirac operator and `H_W` is its Hermitian Wilson kernel. The construction is meaningful only if `sign(H_W)` exists and is well behaved. In the free theory, in momentum space `H_W(q)` is a Hermitian matrix for each `q`, and
```text
sign(H_W)(q) = H_W(q) / |H_W(q)|,   |H_W(q)| := (H_W(q)^2)^{1/2}.
```

### 1.2 The gap condition

`sign(H_W)(q)` is well defined and *smooth in `q`* iff
```text
(G)   there exists μ > 0 with  spec(H_W(q)) ∩ (−μ, μ) = ∅   for all q in the Brillouin zone,
```
i.e. `H_W(q)` has **no zero eigenvalue anywhere**, with a uniform lower bound `μ` on `|eigenvalue|`. Equivalently `H_W^2 ≥ μ^2 > 0` as a positive operator, uniformly in `q`.

Two distinct roles of `(G)`:

- **Existence/definiteness.** Without `H_W(q)` invertible at every `q`, `sign` is undefined at the bad `q`; the operator has a hole.
- **Regularity/locality.** A *uniform* `μ` is what later upgrades `sign` from merely defined to *real-analytic* in `q`, which is the mechanism that produces exponential decay of the position-space kernel (§3). A pointwise-only nonzero `H_W(q)` with `inf_q |H_W(q)| = 0` is fatal for locality even when `sign` is defined everywhere.

### 1.3 Where the null-edge kernel stands

For the null-edge flavored-mass kernel the gap question is *not* generic and is in fact the central open hazard:

- The flat null-edge symbol has a rich determinant-zero locus. `NullEdgeNodalSetExhaustion` (C64) records that the four certified branch curves plus the origin do **not exhaust** the scalar determinant-zero set, and that the modeled species-split term does **not** control (gap) the whole locus. So the analogue of `(G)` is **not** known to hold for the bare kernel; uncontrolled zeros remain.
- `NullEdgeMassiveBranchLifting` (C20) is exactly the finite test of whether a constant mass block `Φ_H` *lifts* those determinant zeros. A clean lift of *all* zeros (with a uniform margin) is the finite shadow of `(G)`. This is the right finite object to certify first.
- The flavored mass / point-splitting kernel (the wave-18 center) is precisely the device whose job is to *create* `(G)` by giving each species/branch a flavor-dependent mass so that the Hermitian kernel develops an everywhere-nonzero spectrum, while a controlled subset of zero crossings carries the index (spectral flow). That is the literature pattern (overlap from naive/minimally-doubled kernels with flavored mass; cf. arXiv:1110.2482 in the context pack).

### 1.4 Gap condition — precise statement to be carried as a hypothesis

```text
(G-fin)  Finite/torus form: for the chosen flavored-mass parameters (r, m, taste signs),
         det H(q) ≠ 0 for every lattice momentum q, AND
         min_q |smallest singular value of H(q)| ≥ μ(L) > 0.

(G-inf)  Uniform form: μ(L) ≥ μ0 > 0 independent of the volume L,
         equivalently inf over the continuous Brillouin zone of |H(q)| ≥ μ0 > 0.
```

`(G-fin)` is necessary for `sign(H)` to even exist on a finite lattice. `(G-inf)` is necessary for locality and is the genuinely hard analytic input. **Do not conflate them** (this is §2).

---

## 2. The finite-volume versus infinite-volume distinction

This is the most common place where the overlap/GW playbook is misapplied, so it is itemized sharply.

### 2.1 Finite volume

On a finite torus `(ℤ/L)^d`:

- The momentum set is finite; every operator is a finite matrix. A spectral "gap" `μ(L) > 0` is **generic** (a finite set of eigenvalues generically misses `0`) but:
  - It is **volume-dependent**: `μ(L)` can shrink to `0` as `L → ∞` if the continuum symbol has a zero or a near-zero. Finite-volume nonvanishing is *not* evidence of an infinite-volume gap.
  - It is **not a locality statement**: every operator on a finite set is trivially "local" (finite support), so finite-volume locality claims are vacuous. Conversely, an overlap operator can be perfectly well defined and "local" on every finite torus while its infinite-volume limit is non-local.
- What finite volume *can* honestly deliver, and what the program already produces: exact finite *index/trace* identities (`naive_index_zero`, `flavored_index_eq_four` in `NullEdgeFlavoredChirality`), branch Krein signatures (`NullEdgeBranchKreinSignatures`), and a finite Krein-positive *physical sector* (`NullEdgeKreinPositiveReleaseCriterion`). These are robust and volume-stable because they are integer/topological, but they are **not** locality and **not** an infinite-volume gap.

### 2.2 Infinite volume / continuum symbol

The meaningful gap and locality statements live here:

- The Brillouin zone becomes the continuous torus `𝕋^d`; `H(q)` is a matrix-valued function on a compact manifold. `(G-inf)` is the statement `inf_{q ∈ 𝕋^d} |H(q)| ≥ μ0 > 0`. Because `𝕋^d` is compact and `H` continuous, `(G-inf)` is equivalent to *pointwise nonvanishing of `det H(q)` everywhere on `𝕋^d`* — i.e. the **full** zero-locus must be empty, not merely the certified curves. This is exactly the exhaustion question that `NullEdgeNodalSetExhaustion` answered *negatively* for the bare/split symbol.
- Only here is `sign(H)` an analytic function and the overlap kernel exponentially decaying.

### 2.3 The audit point

```text
Finite-volume gap  =/=>  infinite-volume gap.
Infinite-volume gap (uniform μ0 over the whole BZ)  ==>  locality (under Hermiticity).
```

The near-term Lean target must therefore be stated as a **finite or uniform-gap proxy** with the volume dependence made explicit, and must *not* be advertised as an infinite-volume locality theorem. The honest finite deliverable is: "for these parameters the full determinant-zero locus is empty (or empty off a controlled index-carrying set), with margin `μ`" — the finite analogue of `(G-inf)` rather than the cheap `(G-fin)`.

---

## 3. The locality condition for the projected / overlap operator

### 3.1 What "local" means for these operators

A lattice operator `D` with position-space kernel `D(x, y)` is **local** in the overlap/GW sense if its kernel decays at least exponentially:
```text
(L)   |D(x, y)| ≤ C · exp(−γ |x − y|),   γ > 0,
```
uniformly (the same `C, γ` for all `x, y`, hence volume-independent). For free operators this is equivalent to `q ↦ D(q)` being real-analytic on a strip around the real Brillouin zone (Paley–Wiener). The width of the analyticity strip controls `γ`.

### 3.2 The chain gap ⇒ locality

In the Hermitian Euclidean setting:
```text
(G-inf)  inf_q |H(q)| ≥ μ0 > 0
   ==>   H(q)/|H(q)| = sign(H)(q) is real-analytic in q with a strip width set by μ0
   ==>   the overlap kernel D_ov(x,y) decays like exp(−γ|x−y|), γ ~ μ0 / (sup-bound).
```
This is the Hernández–Jansen–Lüscher locality theorem pattern: the overlap operator is local provided the Hermitian kernel is gapped (`|H| ≥ μ0`) and bounded above. The bound `γ` degrades as `μ0 → 0`; at `μ0 = 0` locality is lost.

### 3.3 What is strictly stronger than what the program already has

The existing finite results give:

- exact index identities (integers),
- branch projector algebra (idempotence, orthogonality, completeness),
- branch chirality and Krein signature.

None of these implies `(L)`. The index is a *single integer* extracted from `sign(H)` at a finite set of crossings; locality is a *quantitative decay statement about the whole operator kernel*. One can have the correct index and a *non-local* operator (this is exactly the SMG / propagator-zero pathology: the index/anomaly survives while locality or unitarity fails — context pack papers arXiv:2311.12790, arXiv:2505.20436, and the in-repo `NullEdgeGateCGhostZeroSafety`).

### 3.4 Locality conditions to be carried as hypotheses

```text
(L1)  Upper bound:  sup_q |H(q)| ≤ Λ < ∞   (automatic for finite-range kernels).
(L2)  Uniform gap:  inf_q |H(q)| ≥ μ0 > 0  (= (G-inf); the load-bearing input).
(L3)  Analyticity transfer: q ↦ sign(H)(q) extends analytically to a strip of width ~ μ0/Λ.
(L4)  Kernel decay: D_ov(x,y) ≤ C e^{-γ|x-y|}, γ = γ(μ0, Λ) > 0, uniform in volume.
```

`(L1)` is cheap. `(L2)` is the crux and is *not* established (§2.2). `(L3)`/`(L4)` are standard *given* `(L2)` and Hermiticity — but Hermiticity is exactly what fails in the null-edge setting (§4).

---

## 4. How the Krein / retarded structure changes the question

This is where the null-edge program departs from the textbook overlap construction, and where naive transfer of Euclidean theorems is illegitimate.

### 4.1 The structural facts in the repo

- The null-edge symbol is the **flat retarded dual-soldered** Clifford symbol; the natural adjoint structure is a **Krein** (indefinite-metric) one, not a Hilbert one. `NullEdgeSuperDiracKreinCore` defines `IsKreinSelfAdjoint J D := J D = D† J` and uses the mass-shell symmetry `J = m^{-1} D`.
- `NullEdgeBranchKreinSignatures` shows the four branches carry signature pattern `(+,−,+,−)`, so the *full* branch sector is Krein-**indefinite** (`branchKreinSig_sum_zero`, `exists_krein_negative_branch`).
- `NullEdgeKreinPositiveReleaseCriterion` therefore replaces "all branches positive" (false) by a **physical-sector projector** `Pphys` retaining only the Krein-positive branches.
- `NullEdgeKreinLockOrigin` is a no-go: the Krein sign assignment is not determined by chirality/taste/energy/grading alone; `J` and `−J` are both fundamental symmetries, so an *external orientation datum* (retarded/advanced sheet, causal orientation) is required to fix the physical sector.

### 4.2 Why the Euclidean theorems do not transfer

1. **`sign(H)` may not exist.** A Krein-self-adjoint operator need not have real spectrum: eigenvalues can come in complex-conjugate or `±` quadruples, and the form can be degenerate on the root subspaces. `(H(q))^2` need not be positive, so `|H(q)| = (H^2)^{1/2}` and hence `sign(H)` may be undefined even where `det H(q) ≠ 0`. The Euclidean gap condition `(G)` must be **replaced** by a *Krein* condition: `H(q)` has real spectrum, is diagonalizable (no Jordan blocks at the crossing), and the eigenvalues are bounded away from `0` AND from the complex plane (a *definiteness* condition on the Krein form restricted to spectral subspaces), uniformly in `q`. This is strictly stronger and genuinely different from Hilbert-space gappedness.

2. **Locality is about the physical sector, not the full space.** The relevant operator is the *projected* one `Pphys D Pphys` (or the overlap built from `sign` of the Krein-positive compression). Locality must be proven for the projected kernel, and `Pphys` itself depends on the Krein-lock orientation datum (§4.1). If `Pphys` is non-local (a generic risk for spectral projectors onto a sector defined by an indefinite form), the projected operator is non-local even if the unprojected `sign` were analytic.

3. **Retarded ≠ self-adjoint.** The retarded kernel is *non-normal*: its resolvent set and pseudospectrum, not its spectrum, govern decay. The finite surrogate already in the repo, `NullEdgeP9RetardedGreenSeries`, encodes the honest finite statement — *if* the retarded kernel is **nilpotent on a vector after `H` steps**, the Neumann/retarded series terminates and gives a finite causal-reach response law. This finite nilpotent reach is the correct finite stand-in for "locality" in the retarded setting; it is **not** the same object as exponential decay of a Hermitian sign-function kernel. A retarded operator can be bounded-spectrum and still have norms of resolvents/powers that grow (pseudospectral non-normality), breaking the analyticity-strip argument of §3.

4. **Ghost-zeros are a Krein-residue phenomenon.** `NullEdgeGateCGhostZeroSafety` records that a determinant/propagator zero produced by the flavored/point-split construction can promote, under gauge coupling, to a **negative-Krein-residue propagating mode** — a ghost — while the index survives. So even a *gapped, local, correct-index* overlap operator is not physically meaningful until the Krein residue signs of the surviving modes are certified positive on the physical sector. This is an *additional* release predicate beyond `(G)` and `(L)`.

### 4.3 The Krein/retarded form of the requirements

```text
(K1)  Real-spectrum gap: spec H(q) ⊂ ℝ, diagonalizable, |λ| ≥ μ0 > 0, uniform in q.
(K2)  Krein-definiteness on spectral subspaces: the Krein form is sign-definite
      on each ± spectral subspace (so sign(H) is Krein-self-adjoint and well-posed).
(K3)  Physical-sector locality: Pphys and Pphys D_ov Pphys have exponentially
      decaying kernels; Pphys is fixed by an explicit causal-orientation datum
      (Krein-lock), not chosen by hand.
(K4)  Positive-residue / ghost-safety: every surviving physical mode has positive
      Krein residue; determinant zeros not removed are certified kinematical
      (not gauge-coupled ghosts).
(K5)  Retarded reach control: a finite nilpotent-reach or pseudospectral bound
      stands in for self-adjoint analyticity; non-normal resolvent growth is bounded.
```

`(K1)`–`(K2)` replace §1's `(G)`; `(K3)` replaces §3's `(L)`; `(K4)`–`(K5)` are *new* obligations with no Euclidean counterpart. **All five are currently open.**

---

## 5. Which theorem should be proved in a positive Euclidean proxy first

The scope guardrail (§7) forbids targeting a continuum locality theorem. The right first target is a **finite spectral-gap / Krein-positive-sector proxy in a positive (Euclidean/Riemannian) reduction**, mirroring the staged path already adopted for Gate D in `NullEdgeD0PositiveProxy` (positive DEC/Hodge-Dirac proxy *before* any Lorentzian/Krein continuum claim).

### 5.1 Recommended near-term Lean target (finite, positive proxy)

> **Proxy gap theorem (positive Euclidean reduction).** Let `H(q)` be the *Hermitian* Euclidean reduction of the flavored-mass null-edge kernel on the finite torus (mostly-plus / Wick-rotated metric, so the Clifford symbol squares to a *positive* form and `H = H†`). For the flavored-mass parameters `(r, m, taste signs ε_ρ)` fixed by the C19 operator-forced rule (`NullEdgeGateCReleaseCriterion`):
>
> 1. `det H(q) ≠ 0` for **every** lattice momentum `q` *except* the controlled index-carrying crossings, and
> 2. there is an explicit margin `μ > 0` with `|H(q)| ≥ μ` off those crossings (the finite analogue of `(G-inf)`, i.e. the *full* zero-locus is controlled, not merely the four certified branch curves — directly answering the gap left open by `NullEdgeNodalSetExhaustion`), and
> 3. the spectral flow / index of `H(q)` across the crossings equals the flavored index already computed (`flavored_index_eq_four`), tying the gap to the existing topological data.

This is finite, decidable-in-principle, and `sorry`-free-achievable. It is the proxy face of `(G)` and the precondition for everything downstream.

### 5.2 Why a *positive Euclidean* proxy specifically

- In the Euclidean Hermitian reduction `H = H†`, so `sign(H)`, `|H|`, and the whole overlap/locality machinery are *available*; the only open input is the gap. This isolates the gap as the single hard fact and removes the Krein complications, exactly as `NullEdgeD0PositiveProxy` isolates positive convergence before the Lorentzian audit.
- It is the literature-validated route: overlap fermions are *constructed and proven local in the Euclidean Hermitian theory first*; the Lorentzian/retarded interpretation is layered on afterward. Proving the proxy reproduces the standard result on the null-edge kernel is the right correctness check before claiming anything Lorentzian.
- It produces immediately reusable finite lemmas: `H(q)` Hermitian, `H(q)^2 ≥ μ^2` off crossings, `sign(H)` well defined, `D_ov = 1 + Γ sign(H)` satisfies the GW relation `{Γ, D_ov} = D_ov Γ D_ov` as a finite matrix identity per `q`.

### 5.3 Secondary targets (still finite, after 5.1)

- **GW relation as a finite identity:** given the proxy gap, prove `D_ov(q)` satisfies Ginsparg–Wilson `Γ D_ov + D_ov Γ = D_ov Γ D_ov` for each `q`. Pure finite algebra once `sign(H)` exists.
- **Krein-positive-sector compatibility:** show the Euclidean physical sector matches the Krein physical sector `Pphys` of `NullEdgeKreinPositiveReleaseCriterion` under the Wick rotation, so the proxy is not certifying a different operator than the Lorentzian target.
- **Finite locality surrogate:** a *bandwidth/decay* estimate on the finite `D_ov(x,y)` with constants depending on `μ` (a finite, volume-tagged exponential-decay bound) — explicitly labeled finite, never claimed as the continuum theorem.

These three are independent and can be attempted in parallel after 5.1.

---

## 6. What would count as a fatal failure or a downgrade to reconstruction only

### 6.1 Fatal failures (kill the local-physical-operator claim outright)

1. **No achievable gap.** If, for *every* admissible flavored-mass parameter choice consistent with the C19 operator-forced signs and gauge covariance, the full determinant-zero locus cannot be emptied off a controlled index set (i.e. `(G-inf)`/proxy-gap is provably unattainable, strengthening `NullEdgeNodalSetExhaustion` from "not exhausted by certified curves" to "uncontrollable"), then `sign(H)` has unremovable holes and no local overlap operator exists. Fatal.
2. **Krein indefiniteness on the physical sector.** If no causal-orientation datum can make the Krein form sign-definite on the would-be physical sector — i.e. `(K2)` fails irreparably and `Pphys` necessarily retains a negative-residue mode — then the operator cannot be unitary/physical. Fatal at the meaning level even if locality holds.
3. **Gauge-coupled ghost.** If a surviving determinant zero is shown to be a genuine gauge-coupled propagator zero (negative Krein residue under weak coupling), per the Golterman–Shamir mechanism (`NullEdgeGateCGhostZeroSafety`; arXiv:2311.12790, arXiv:2505.20436), unitarity is lost. Fatal: index survival does not rescue it.
4. **Non-normal locality breakdown.** If the retarded (non-self-adjoint) kernel has resolvent/pseudospectral growth that defeats any analyticity-strip / nilpotent-reach bound (`(K5)` fails), the projected operator is non-local in the infinite-volume limit. Fatal for the locality claim.

### 6.2 Downgrade to "reconstruction only" (no fatal contradiction, but no local physical operator either)

If the obstruction is not a contradiction but an *unremovable dependence on extra structure*, the honest outcome is to **downgrade the claim from "local physical operator" to "reconstruction/effective description only"**:

- **Sector-dependent locality.** `D_ov` is local only *after* projection by a `Pphys` that is itself non-local (or depends on a global orientation choice). Then the operator is meaningful as a *reconstructed effective operator on the physical sector*, not as a local lattice operator. Downgrade: keep the index/sector results, drop the locality claim.
- **Gap only at finite volume.** `(G-fin)` holds with `μ(L) → 0`; the operator is well defined on each torus but has no infinite-volume limit. Downgrade to a finite-volume / regulator-level statement.
- **Orientation-dependent meaning.** The Krein-lock no-go (`NullEdgeKreinLockOrigin`) means the physical sector — and hence the operator's particle/antiparticle and in/out interpretation — is fixed only relative to an external causal-orientation convention. If that datum cannot be derived intrinsically, the operator is meaningful *relative to a chosen reconstruction*, not absolutely. Downgrade: state the result conditional on the orientation datum, as the existing modules already do (`branchKreinSig` relative to chosen `J`).
- **Index without dynamics.** If only the spectral-flow/index survives (it is robust) but neither locality nor positive residues can be certified, retain the program's existing honest claim: a finite *index/anomaly* statement and a *kinematical* branch description, explicitly **not** a propagating local physical operator. This matches the program's standing discipline ("a computed flavored index must not release Gate C on its own", `NullEdgeGateCGhostZeroSafety`).

### 6.3 Release calculus (one line)

```text
RELEASE local-physical-operator  ⇐  (G-inf/proxy gap) ∧ (K2 Krein-definite sector)
                                     ∧ (K3 physical-sector locality) ∧ (K4 positive residues)
                                     ∧ (K5 retarded reach control).
Any single failure ⇒ fatal (§6.1) or downgrade-to-reconstruction (§6.2);
finite index/sector results are retained in all cases.
```

---

## 7. Scope guardrail compliance

- The recommended next Lean target (§5.1) is a **finite spectral-gap / positive Euclidean proxy theorem**, not a continuum locality theorem.
- The continuum locality statement is itemized only as a *list of analytic assumptions* (`(L1)`–`(L4)`, `(K1)`–`(K5)`) to be carried as hypotheses, never proposed as the near-term proof obligation.
- The Euclidean Hermitian overlap/GW results are used strictly as a *comparison baseline*; §4 explicitly blocks their automatic transfer to the Lorentzian/Krein/retarded null-edge setting and replaces each with its Krein analogue.

---

## 8. Dependency-ordered checklist (for the next wave)

```text
[ ] P0  Fix the Wick-rotated positive Euclidean Hermitian reduction H(q) of the
        flavored-mass null-edge kernel; prove H = H† as a finite identity.
[ ] P1  (§5.1) Proxy gap: det H(q) ≠ 0 off the controlled index crossings, with
        explicit margin μ; full-locus control strengthening NullEdgeNodalSetExhaustion.
[ ] P2  Spectral-flow/index of H(q) = flavored_index_eq_four (tie gap to topology).
[ ] P3  sign(H), |H| well defined; D_ov = 1 + Γ sign(H); finite GW identity per q.
[ ] P4  Finite (volume-tagged) exponential-decay surrogate for D_ov(x,y) in terms of μ.
[ ] P5  Match the Euclidean physical sector to the Krein Pphys (Wick-rotation bridge).
--- analytic / continuum layer (NOT near-term Lean targets) ---
[ ] A1  (G-inf) uniform gap μ0 over the full Brillouin zone.
[ ] A2  (K1)-(K2) Krein real-spectrum gap + sector definiteness.
[ ] A3  (K3) physical-sector locality with intrinsically-fixed Pphys orientation.
[ ] A4  (K4) positive-Krein-residue / ghost-safety under gauge coupling.
[ ] A5  (K5) retarded non-normal reach / pseudospectral control.
```

P0–P5 are finite and `sorry`-free-achievable; A1–A5 are the analytic assumptions whose status determines release vs. downgrade (§6).

---

## 9. One-paragraph conclusion

An overlap or Ginsparg–Wilson physical operator built from the null-edge flavored-mass kernel may be called local and meaningful only after a **chain of preconditions that the Euclidean Hermitian playbook makes look automatic but which are all open here**: a uniform Hermitian-kernel gap `inf_q |H(q)| ≥ μ0 > 0` (§1), proven in *infinite* volume rather than merely finite volume (§2), upgraded to exponential kernel decay of the *projected* operator (§3), and — crucially — re-derived in the *Krein/retarded* setting where `sign(H)` may not exist, locality is a physical-sector statement tied to a causal-orientation datum, and surviving determinant zeros must be certified ghost-free (§4). The correct near-term Lean target is a **finite positive-Euclidean proxy gap theorem** (§5) with the continuum/Krein inputs carried as an explicit assumption list (§6, §8); failure of the gap, of Krein sector-definiteness, of ghost-safety, or of retarded reach control is fatal, while an unremovable dependence on projection or orientation downgrades the claim to reconstruction-only, with the program's finite index/sector results retained in every case.
```

# Aristotle semantic context pack

Generated: 2026-07-21T03:40:02
Query: `HNU endpoint exact product of projector-conditioned unitary exponentials sharp commutator Lie Trotter bound polynomial changing-cell step schedule massive Dirac continuum`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/aristotle-downloads/f0d38cd0-cdec-46ef-800b-b588e3e07740/output-final_aristotle/CODEX_VISIONARY_CONTINUUM_3PLUS1_SYNTHESIS_2026-07-13_18.md` [Bridge B: HNU infrared tangent and quantitative scaling]

Score: `0.831`

```text
### Bridge B: HNU infrared tangent and quantitative scaling

**B1. Exact tangent.** Compute the derivative of the corrected depth-eight HNU
endpoint at the origin and identify the resulting Pauli/Weyl symbol, including
sign, axis order, and time normalization.

**B2. Uniform one-step error.** On a compact momentum ball, prove an explicit
operator-norm bound between the rescaled HNU endpoint and the exact continuum
Weyl/Dirac exponential. The coefficient must be displayed, not hidden behind
big-O notation.

**B3. Many-step compact-momentum limit.** Telescope B2 using exact unitarity to
obtain a fixed-time error that vanishes with lattice spacing.

**B4. Changing-lattice `L2` limit.** Compose B3 with the accepted bulk/tail and
Fourier transport machinery. State the sampling/interpolation maps and retain
the ultraviolet tail hypothesis.
```

### 2. `AutonomousLab/work/role-activations/CODEX_VISIONARY_CONTINUUM_3PLUS1_SYNTHESIS_2026-07-13_18.md` [Bridge B: HNU infrared tangent and quantitative scaling]

Score: `0.831`

```text
### Bridge B: HNU infrared tangent and quantitative scaling

**B1. Exact tangent.** Compute the derivative of the corrected depth-eight HNU
endpoint at the origin and identify the resulting Pauli/Weyl symbol, including
sign, axis order, and time normalization.

**B2. Uniform one-step error.** On a compact momentum ball, prove an explicit
operator-norm bound between the rescaled HNU endpoint and the exact continuum
Weyl/Dirac exponential. The coefficient must be displayed, not hidden behind
big-O notation.

**B3. Many-step compact-momentum limit.** Telescope B2 using exact unitarity to
obtain a fixed-time error that vanishes with lattice spacing.

**B4. Changing-lattice `L2` limit.** Compose B3 with the accepted bulk/tail and
Fourier transport machinery. State the sampling/interpolation maps and retain
the ultraviolet tail hypothesis.
```

### 3. `AgentTasks/overnight-null-information-run-2026-07-10/2026-07-10_ARISTOTLE_POST_ROUTEB_STABILITY_AUDIT_11.md` [2. Independent check of S18 (`FixedMomentumManyStepContinuum`)]

Score: `0.829`

```text
se**
  upper bound (44.4 vs the true 0.571); the `bound_ok` check passes trivially.

**Where the `D(k,m)t²/n` bound actually lives — the precise answer requested.**

- The **shape** `error ≤ D(k,m)·t²/n` (fixed-time operator-norm, first-order
  splitting) is the standard Trotter estimate and is **attributed to a landed
  Lean theorem** `FixedMomentumManyStepContinuum.fixed_time_many_step_bound`,
  with convergence `…fixed_time_many_step_tendsto` and unitarity
  `…walk_mem_unitary`. **These declarations are NOT in this snapshot —
  [packaging].** Their correctness cannot be, and is not, asserted here beyond
  the packaging fact; Audit 12 with `PhysicsSM` in scope must confirm the Lean
  `D(k,m)` matches the claimed shape.
- The **specific constant** used by the Python (`ckm`, `dkm`) is a **harness
  reconstruction**, not necessarily the Lean constant. The harness only
  **numerically checks** `error ≤ dkm·t²/n` at `n=8..512`.
- The **monotonicity** and **`error(512)<0.003`** gates are **purely numerical
  harness checks**, not Lean theorems.
- The **analytic target `exp(−iHt)` is imported** (a closed-form 2×2 exponential),
  not derived from a PDE/infinite-volume propagator.

**S18 verdict:** an honest **V2 reproduction** of accepted 1+1 fixed-momentum
free-Dirac propagation. Precisely: *convergence + the `t²/n` bound = Lean
(imported anchor, [packaging] here); monotonicity + final-error = numerics;
analytic target = imported closed form.* Not a prediction, not a
position-space/PDE/`3+1` result — exactly as the manifest states.

---
```

### 4. `AgentTasks/overnight-null-information-run-2026-07-10/LIT_SEARCH_LOG.md` [2026-07-10 05:10 PDT | Claude | lit/package pass 2]

Score: `0.827`

```text
graph returned no useful product-formula hit. Primary literature confirms first-order Lie-Trotter bounds for general noncommuting summands and warns that simple upper bounds can be very loose; explicit lower bounds make noncommutation a real first-order control. Action: retain the audited `O(1/n)` compact-box target and its deliberately generous constant; any `O(1/n^2)` claim requires a separate palindromic step. |
```

### 5. `AgentTasks/overnight-null-information-run-2026-07-10/2026-07-10_ARISTOTLE_POST_ROUTEB_STABILITY_AUDIT_11.md` [2. Independent check of S18 (`FixedMomentumManyStepContinuum`)]

Score: `0.825`

```text
## 2. Independent check of S18 (`FixedMomentumManyStepContinuum`)

Harness: `Scripts/null_information_lab.py::s18_free_dirac_propagator`, `k=3/5`,
`m=4/5`, `t=1`, `c=ħ=1`, binary64 2×2 complex matrices.

**Analytic reference — [true].** `H = kσ_z + mσ_x = [[k,m],[m,−k]]`, `ω=√(k²+m²)`.
The imported `exact` matrix is exactly
`exp(−iHt) = cos(ωt)·I − i·(sin(ωt)/ω)·H`, i.e.
`[[cosωt − i(sinωt/ω)k, −i(sinωt/ω)m],[−i(sinωt/ω)m, cosωt + i(sinωt/ω)k]]`.
Recomputed identical to the harness. The step is
`walk = shift(kε)·coin(mε)` with `shift=exp(−ikεσ_z)`, `coin=exp(−imεσ_x)`
(`mass_phase=−1`) — a **first-order Lie–Trotter split** of `exp(−iεH)`.

**Error metric — [true].** Frobenius norm of `walk^n − exact`; a legitimate 2×2
operator-difference norm.

**Displayed `1/n` bound — recomputed.** Independent run:

```
n        :   8       16      32      64      128     256     512
error    : 0.07147 0.03571 0.01785 0.008925 0.004463 0.002231 0.001116
n·error  : 0.5718  0.5714  0.5712  0.5712   0.5712   0.5712   0.5712
D t²/n   : 5.55    2.78    1.39    0.694    0.347    0.173    0.0867
```

- **Convergence is genuinely `O(1/n)`**: `n·error → 0.5712` constant. This is the
  correct first-order Trotter rate; the true leading constant is ≈0.571,
  dominated by `½‖[σ_z,σ_x]‖`-type commutator content.
- **Monotone** (each halving): pass. **Final** `error(512)=0.001116 < 0.003`,
  `error(8)/error(512)=64.1 > 50`: pass. **Wrong mass phase** → `1.904`
  (`>0.5`, `>100×` correct): control fails as documented. All [true].
- The harness constant `D(k,m)≈44.4` makes `D t²/n` a **valid but very loose**
  upper bound (44.4 vs the true 0.571); the `bound_ok` check passes trivially.

**Where the `D(k,m)t²/n` bound actually lives — the precise answer requested.**

- The **shape** `error ≤ D(k,m)·t²
```

### 6. `AgentTasks/overnight-null-information-run-2026-07-10/LIT_SEARCH_LOG.md` [2026-07-10 05:10 PDT | Claude | lit/package pass 2]

Score: `0.824`

```text
tors. First-order unsymmetrized Trotter error is the correct target because the Clifford summands do not commute. The local thermodynamic search adds no stronger source than PhysLean's finite fluctuation theorem; S22 therefore remains an independent theorem confrontation rather than a material fit. Action: launch the exact sign-table/eigenbasis/position-symbol bridge and a compact-box `3+1` `O(1/n)` proof; retain a commutator control against any `O(1/n^2)` over-claim. |
| 2026-07-10 06:32 PDT | Codex + Spark | finite unitary path actions and exact EOM terminology | Spark local Neo4j abstract/chunk search followed by primary web lookup | Debbasch, arXiv:1806.02313; D'Ariano et al., arXiv:1406.1021; Mlodinow-Brun, arXiv:1802.03910; McClean-Parkhill-Aspuru-Guzik, PNAS 2013, DOI 10.1073/pnas.1308069110 | Debbasch supplies a genuine stationary discrete action for unitary quantum automata; Feynman's clock supplies the closest quadratic variational-history precedent. No source in the scoped corpus identifies `sum_t ||psi_(t+1)-U psi_t||^2` as the canonical Dirac-walk action. Action: caption `FiniteUnitaryPathAction` as a positive least-residual action characterization whose zero locus is the selected EOM, not as a primitive derivation of the walk or as the shared Pluecker field action. |
| 2026-07-10 06:32 PDT | Codex | bounded noncommuting product-formula rates | Spark failed from context exhaustion; direct Neo4j abstract/chunk fallback, then primary arXiv search | Childs-Su-Tran-Wiebe-Zhu, arXiv:1912.08854; Hahn-Hartung-Burgarth-Facchi-Yuasa, arXiv:2410.03059 | The local scoped graph returned no useful product-formula hit. Primary literature confirms first-order Lie-Trotter bounds for general noncommuting summands and warns that simple upper bounds can be very loose; explici
```

### 7. `PhysicsSM/Draft/NullEdge/QuantitativeDiracWalkContinuum.lean` [shape]

Score: `0.819`

```text
theorem shape; no external code or continuum conclusion is imported. Aristotle
job `ca016cbf-3151-4aef-b9ab-16f3f22b6247` produced the proof draft. The two
remaining derivative holes were excluded from this live module; the explicit
remainder proof was repaired and checked locally under the pinned toolchain.

**Recorded blocker (rung 4, fixed-momentum Lie–Trotter).** A theorem of the form
`(Ustep (k·t/n) (m·t/n))^n → exp(-i·t·H(k,m))` is *not* landed here. It needs a
complete normed-algebra matrix-exponential Trotter estimate on
`Matrix (Fin 2) (Fin 2) ℂ` (a submultiplicative operator-norm instance plus a
product/exponential comparison); the entrywise `mnorm` proved here is only
`2`-submultiplicative, which is not directly the operator norm Trotter needs.
The explicit `O(ε²)` remainder bound is landed instead, as permitted. The
separate second-derivative proof remains open and is not claimed by this module.
-/

open Matrix Complex Real
open PhysicsSM.Draft.NullEdge.Carrier.ContinuumLimit
```

### 8. `AgentTasks/overnight-null-information-run-2026-07-10/2026-07-10_ARISTOTLE_POST_JOINT_SPATIAL_AUDIT_13.md` [3. Truth audit of the proposed `D4 = 16 B² exp B` local Trotter constant]

Score: `0.819`

```text
## 3. Truth audit of the proposed `D4 = 16 B² exp B` local Trotter constant

Object: `Compact3Plus1DiracRate/Core.lean`,
`one_step_to_exact_flow_bound`:
`‖splitStep(k,m,ε) − exactFlow(k,m,ε)‖ ≤ D4·ε²` for `|ε|≤1`, with
`B = |kx|+|ky|+|kz|+|m|`, `D4 = 16 B² e^B`.

**Structure recomputed.** Each `factor(q,g) = cos q · I − i sin q · g`. For `g`
Hermitian with `g²=1`, this is **exactly** `exp(−i q g)`. Hence
`splitStep = e^{−iεkxα₁} e^{−iεkyα₂} e^{−iεkzα₃} e^{−iεmβ}` and
`exactFlow(ε) = e^{−iεH}`, `H = kxα₁+kyα₂+kzα₃+mβ`. Setting `A_j = −iε·c_j g_j`
(`c_j ∈ {kx,ky,kz,m}`, `‖g_j‖=1`), we have `‖A_j‖ = |ε||c_j|` and
`a := Σ‖A_j‖ = |ε|B ≤ B`.

**Plausible: yes.** The standard first-order product estimate
`‖∏ e^{A_j} − e^{ΣA_j}‖ ≤ (Σ_{i<j}‖A_i‖‖A_j‖)·e^{Σ‖A_k‖}` gives, with
`Σ_{i<j}‖A_i‖‖A_j‖ ≤ ½(Σ‖A_j‖)² = ½ε²B²` and `e^{|ε|B} ≤ e^B`,
`‖splitStep − exactFlow‖ ≤ ½ B² e^B · ε²`.
So `D4 = 16 B² e^B` is a **valid over-estimate** — the deliberately generous
constant is provable, and the docstring's "deliberately generous" is honest.

**Sharpenable by exactly 32×.** The sharp simple constant is `½ B² e^B`;
`D4 / (½B²e^B) = 32`. Recommend either landing `D4` as-is (headroom absorbs any
proof slack) or tightening to `½ B² e^B`. Empirical leading coefficient at the
`(1,2,2,3)` witness (`B=8`): `‖·‖/ε² → 11.36` as `ε→0`; both `D4·ε²` and
`½B²e^B·ε²` bound the true error with large margin (at `ε=0.01`: true error
`1.14e−3`, `½B²e^B·ε² = 9.54`, `D4·ε² = 305`).

**No counterexample; rate is genuinely `O(1/n)`, not `O(1/n²)`.** The generators
**anticommute** (`{α_i,α_j}=0`, `{α_i,β}=0`), so `[α₁,α₂]=2α₁α₂≠0`
(recomputed `(α₁α₂)_{00}=I≠−I=(α₂α₁)_{00}`). The leading Trotter error is
therefore genuinely nonzero: `n·error → const > 0`. Any promotion of the
**unsymmetrized** `x,y,z,mass` product
```

## Scoped paper hits

### 1. A Theory of Trotter Error

Score: `0.818`
Zotero key: `U5M94GFX`
arXiv: `1912.08854`
DOI: `10.1103/PhysRevX.11.011020`
URL: http://arxiv.org/abs/1912.08854

Abstract:

The Lie-Trotter formula, together with its higher-order generalizations, provides a direct approach to decomposing the exponential of a sum of operators. Despite significant effort, the error scaling of such product formulas remains poorly understood. We develop a theory of Trotter error that overcomes the limitations of prior approaches based on truncating the Baker-Campbell-Hausdorff expansion. Our analysis directly exploits the commutativity of operator summands, producing tighter error bounds for both real- and imaginary-time evolutions. Whereas previous work achieves similar goals for systems with geometric locality or Lie-algebraic structure, our approach holds in general. We give a host of improved algorithms for digital quantum simulation and quantum Monte Carlo methods, including simulations of second-quantized plane-wave electronic structure, $k$-local Hamiltonians, rapidly decaying power-law interactions, clustered Hamiltonians, the transverse field Ising model, and quantum ferromagnets, nearly matching or even outperforming the best previous results. We obtain further speedups using the fact that product formulas can preserve the locality of the simulated system. Specifically, we show that local observables can be simulated with complexity independent of the system size for power-law interacting systems, which implies a Lieb-Robinson bound as a byproduct. Our analysis reproduces known tight bounds for first- and second-order formulas. Our higher-order bound overestimates the complexity of simulating a one-dimensional Heisenberg model with an even-odd ordering of terms by only a factor of $5$, and is close to tight for power-law interactions and other orderings of terms. This suggests that our theory can accurately characterize Trotter err
...[truncated]

### 2. Dirac equation with an ultraviolet cutoff and a quantum walk

Score: `0.755`
Zotero key: `G7NXEZBU`
DOI: `10.1103/physreva.81.012314`

### 3. Locality properties of Neuberger's lattice Dirac operator

Score: `0.754`
Zotero key: `BEG87SU5`
arXiv: `hep-lat/9808010`
URL: https://arxiv.org/abs/hep-lat/9808010

### 4. The Dirac equation as a quantum walk: higher dimensions, observational convergence

Score: `0.748`
Zotero key: `4F87TGCN`
arXiv: `1307.3524`
DOI: `10.1088/1751-8113/47/46/465302`

### 5. Dirac quantum walk on tetrahedra

Score: `0.744`
Zotero key: `8RZQA73D`
arXiv: `2404.09840`
DOI: `10.1103/physreva.110.042418`
URL: http://arxiv.org/abs/2404.09840

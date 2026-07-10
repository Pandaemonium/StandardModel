# The continuum reduction of the carrier's transfer step (one channel)

Strategy + design note, with a landed finite kernel lemma set in
`RequestProject/ContinuumLimit.lean`.

Conventions: `σ_x, σ_z` Pauli matrices; lattice spacing `a`, time step `dt`,
mass `m`, mass angle `θ = m·dt`; momentum `k`; `c = ħ = 1`. All matrices below
are the actual `Matrix (Fin 2) (Fin 2) ℂ` objects proved about in the Lean file.

---

## 1. The continuum-limit claim, stated precisely (import vs. open)

### 1.1 The object

One step of the 1D Dirac quantum walk (Feynman checkerboard = 2-component /
`Cl(1,1)` coin) is, in momentum space,

```
Û(k) = S(k) · C(θ),   S(k) = exp(-i k a σ_z),   C(θ) = exp(-i θ σ_x),  θ = m dt.
```

In the light-cone scaling `a = dt = ε` this is `Û_ε(k) = e^{-iεkσ_z} e^{-iεmσ_x}`
(k physical, absorbed `a=1` in the Lean file so `Ushift k = e^{-ikσ_z}`,
`Ucoin θ = e^{-iθσ_x}`, `Ustep k θ = Ushift k · Ucoin θ`).

### 1.2 Exact finite facts (these are the `[import]`-independent kernel truths)

* **Trace / determinant.** `tr Û(k) = 2 cos(ka) cos θ` and `det Û(k) = 1`, so
  `Û(k) ∈ SU(2)` with eigenvalues `e^{∓ i ω(k)}` where

  ```
  cos ω(k) = cos(ka) · cos(θ)          (exact lattice dispersion).
  ```

  (Lean: `Ustep_trace`, `Ustep_det`.)

* **Small-argument expansion.** `cos ω = 1 - ½(k²a² + θ²) + O(4)` gives
  `ω/dt → √(k² + m²)` — the relativistic dispersion `E = √(k²+m²)`. The finite
  matrix content of `E² = k²+m²` is the **mass-shell / Clifford identity**
  `(k σ_z + m σ_x)² = (k²+m²)·1` (Lean: `dirac_mass_shell`, plus the coin
  Clifford relations `sigmax_sq`, `sigmaz_sq`, `sigma_anticomm`).

* **Massless light cone.** At `θ = 0`, `Û(k) = diag(e^{-ika}, e^{+ika})`, so
  `ω(k) = ka` is exact and the group velocity `dω/d(ka) = ±1` exactly (Lean:
  `Ushift_eq_exp`).

* **Leading-order symbol match.** `d/dε [Û_ε(k)]|_{ε=0} = -i(k σ_z + m σ_x)`,
  i.e. `Û_ε(k) = 1 - iε(k σ_z + m σ_x) + O(ε²)`. The generator is exactly the
  1+1D **Dirac Hamiltonian symbol** `H(k) = k σ_z + m σ_x` (Lean:
  `Ustep_hasDerivAt_generator`).

### 1.3 The continuum theorem (sharpest TRUE statement) and the import split

Let `H_ε(k) = (i/ε) log Û_ε(k)` be the (real-analytic near `ε=0`) effective
generator; `H_ε(k) → H(k) = k σ_z + m σ_x` and, after `N = t/ε` steps,

```
Û_ε(k)^{t/ε}  →  e^{-i t H(k)} = e^{-i t (k σ_z + m σ_x)}   as ε → 0.
```

In position space `k → -i∂_x`, so the limit propagator is `e^{-t(σ_z ∂_x + i m σ_x)}`,
the 1+1D Dirac evolution (matches the prompt's target exactly).

* **Scaling:** lattice spacing `a = dt = ε → 0`, mass held fixed so the mass
  angle `θ = mε → 0` (small-mass-angle regime), momentum `k` fixed / bandlimited.
* **Mode of convergence — sharpest honest form:**
  - *On bandlimited wave packets* (states with `supp ψ̂ ⊂ [-K,K]`): convergence is
    **strong, uniform on compact `t`-intervals**, because `H_ε(k) → H(k)`
    uniformly on `|k| ≤ K` (here `sin(ka)/a → k` uniformly). This is a finite-`H`
    Trotter estimate on each `k`-fibre plus dominated bandlimited assembly.
  - *On the full Hilbert space* `L²(ℝ)⊗ℂ²`: **strong operator convergence** of the
    propagators (equivalently **strong resolvent convergence** of the generators),
    via Trotter–Kato / Chernoff. Norm convergence FAILS (the discrete symbol is
    `2π/a`-periodic in `k`, so it cannot match the unbounded Dirac symbol uniformly).

* **`[import]` vs. open:**
  - `[import]` (Gersch 1981; Jacobson–Schulman 1984): the **1+1D checkerboard**
    continuum limit to the Dirac propagator. The 2-component DQW above *is* the
    checkerboard, so §1.3 for one channel is the imported result — the finite
    lemmas here only certify the *symbol data* that the import converges to.
  - **Open** (this program's §9/§10): the analogous continuum theorem for the
    actual multi-edge `Cl(4)` carrier (see §2).

---

## 2. The obstruction: lifting 1+1D → the `Cl(4)` carrier

The multi-edge carrier is a `Cl(4)` walk: a **4-dimensional coin** (Dirac spinor).
Mlodinow–Brun give necessary conditions for a QW to have a Dirac continuum limit:

1. **4D coin** carrying a rep of the relevant Clifford algebra (the coin
   generators must furnish anticommuting `γ`-matrices: `{γ_μ, γ_ν} = 2 η_{μν}`),
2. **parity/reflection symmetry** relating left/right (and, in `d>1`, the several
   edge directions) so the linear-in-`k` term is `Σ_j γ_j ∂_j` with no even-order
   defect surviving,
3. **noncorrelation** (product/separable coin action across directions) so the
   multi-step symbol factorizes and BCH cross-terms are `O(ε²)`, leaving a clean
   first-order Dirac generator.

**Where the gap is.** For one channel (`Cl(1,1)`, 2D coin) all three hold and are
finitely certified here: the coin Clifford relations (`sigmax_sq`, `sigmaz_sq`,
`sigma_anticomm`) give condition 1; `Ushift_eq_exp` (symmetric `e^{∓ika}` shift)
gives the parity/light-cone structure; `Ustep_hasDerivAt_generator` gives the
clean first-order generator `k σ_z + m σ_x` (no `O(ε)` defect), i.e. conditions
2–3 at leading order. The mass-shell `dirac_mass_shell` is the `Cl(1,1)` special
case of `(Σ p_μ γ_μ)² = (p·p)·1`.

The **open** step is to verify the same three conditions for the carrier's actual
4-edge coin: (a) that its four edge-transfer generators realize a genuine
`Cl(4)` (four *anticommuting* generators, not merely four matrices), (b) that the
multi-edge shift is parity-symmetric so first order gives `Σ_j γ_j ∂_j`, and
(c) that the edges act noncorrelated so BCH cross-terms are `O(ε²)`. If any fails,
the first-order symbol acquires a defect (a non-Dirac term or a fermion-doubling
partner) and there is no Dirac PDE limit. This (a)+(b)+(c) verification for the
concrete carrier coin is exactly the §9/§10 open problem; only the 1+1D reduction
is imported.

---

## 3. Finite kernel target (landed)

File `RequestProject/ContinuumLimit.lean` (builds, no `sorry`, axioms
`propext`/`Classical.choice`/`Quot.sound` only):

| Lemma | Statement | Meaning |
|---|---|---|
| `Ustep_trace` | `tr(Ustep k θ) = 2 cos k cos θ` | dispersion (trace part) |
| `Ustep_det` | `det(Ustep k θ) = 1` | `SU(2)`, eigenvalues `e^{∓iω}`, `cos ω = cos k cos θ` |
| `Ushift_eq_exp` | `Ushift k = diag(e^{-ik}, e^{ik})` | massless light cone, `ω=k`, `dω/dk=±1` exact |
| `sigmax_sq`,`sigmaz_sq`,`sigma_anticomm` | `σ_x²=σ_z²=1`, `{σ_z,σ_x}=0` | coin Clifford relations (Mlodinow–Brun cond. 1) |
| `dirac_mass_shell` | `(k•σ_z + m•σ_x)² = (k²+m²)•1` | relativistic mass shell `E²=k²+m²` |
| `Ustep_hasDerivAt_generator` | `d/dε[Ustep(kε,mε)]|_0 = -i(k σ_z + m σ_x)` | **leading-order symbol match to the Dirac Hamiltonian** |

The sharpest single finite statement toward the continuum limit is
`Ustep_hasDerivAt_generator`: it certifies that the one-step transfer operator's
generator is *exactly* the Dirac symbol `H(k) = k σ_z + m σ_x` to first order —
the precise sense in which the discrete walk "is" a discretized Dirac equation.
`dirac_mass_shell` is the finite content of relativistic dispersion, and the
`trace`/`det` pair gives the exact lattice dispersion `cos ω = cos k cos θ`.

---

## 4. Feasibility and honest boundary

**Finitely provable (kernel, done here):** every algebraic/symbol fact — exact
dispersion (trace+det), mass shell / Clifford relations, exact massless light-cone
group velocity, and the first-order generator match. These are matrix identities
and a single-variable derivative; no continuum machinery.

**Requires functional-analytic continuum machinery (outside the finite kernel):**
the propagator convergence `Û_ε^{t/ε} → e^{-itH}` itself — this needs
Trotter–Kato / Chernoff, strong-resolvent convergence, and the `L²⊗ℂ²` functional
setting. It is not a finite statement and is not expressible as a kernel matrix
lemma.

**Honest position.** A full continuum theorem is **not** in scope of the finite
kernel program. The correct stance is: *the 1+1D continuum limit is imported*
(Gersch; Jacobson–Schulman — the checkerboard/`Cl(1,1)` channel), the finite
symbol data that limit must match is now kernel-certified here, and the
**`Cl(4)` carrier's continuum limit remains open**, gated on the Mlodinow–Brun
conditions (anticommuting `Cl(4)` generators + parity + noncorrelation) for the
concrete 4-edge coin. A correct finite symbol/group-velocity lemma set is
delivered; the semigroup-convergence theorem is deliberately left as the imported
(1+1D) / open (`Cl(4)`) boundary.

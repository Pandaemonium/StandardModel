# Summary of changes for run fd78ae68-65bb-41e3-9fb1-2bc7c03d0b3b
Delivered a strategy + design note **and** a landed finite kernel lemma set for the continuum reduction of the carrier's transfer step (one channel).

**Strategy note** (`STRATEGY_CONTINUUM_LIMIT.md`) covers all four requested items:
1. **Precise continuum-limit claim + import/open split.** For the 1D Dirac quantum walk `Û(k)=e^{-ikaσz}e^{-iθσx}` (θ=m·dt) in the light-cone scaling a=dt=ε→0, θ=mε→0, k fixed/bandlimited: `Û^{t/ε}→e^{-it(kσz+mσx)}`, i.e. `e^{-t(σz∂x+imσx)}` (the prompt's target). Sharpest true mode: strong (uniform-on-compact-t) convergence on bandlimited wave packets, strong operator / strong-resolvent convergence on `L²⊗ℂ²` (norm convergence fails). The 1+1D checkerboard limit (Gersch; Jacobson–Schulman) is the `[import]`; the multi-edge Cl(4) carrier limit is open.
2. **Cl(4) obstruction.** Stated via the Mlodinow–Brun conditions (4D coin realizing anticommuting Clifford generators + parity + noncorrelation), showing all three hold and are finitely certified for the Cl(1,1) channel, and pinpointing the open gap: verifying genuine anticommuting Cl(4) generators, parity-symmetric multi-edge shift, and noncorrelated edges for the concrete 4-edge coin.
3. **Finite kernel target.** Sharpest finite statement is the leading-order symbol match to the Dirac Hamiltonian, plus the exact dispersion and mass shell.
4. **Feasibility/boundary.** All symbol/algebraic facts are finite and done; propagator (semigroup) convergence needs Trotter–Kato machinery outside the finite kernel — honest position: imported for 1+1D, open for the carrier.

**Landed Lean lemmas** (`RequestProject/ContinuumLimit.lean`, imported by `RequestProject/Main.lean`; builds with no `sorry`, axioms limited to propext/Classical.choice/Quot.sound):
- `Ustep_trace`: `tr(Ustep k θ)=2 cos k cos θ`; `Ustep_det`: `det=1` — together the exact lattice dispersion `cos ω = cos k cos θ` with eigenvalues `e^{∓iω}`.
- `Ushift_eq_exp`: shift `= diag(e^{-ik},e^{ik})` — exact massless light cone, group velocity ±1.
- `sigmax_sq`, `sigmaz_sq`, `sigma_anticomm`: coin Clifford relations.
- `dirac_mass_shell`: `(k•σz+m•σx)² = (k²+m²)•1` — finite content of `E²=k²+m²`.
- `Ustep_hasDerivAt_generator`: `d/dε[Ushift(kε)·Ucoin(mε)]|₀ = -i(kσz+mσx)` — the leading-order match of the discrete transfer generator to the Dirac Hamiltonian symbol.

All work is committed and pushed.

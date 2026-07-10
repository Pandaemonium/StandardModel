# Summary of changes for run 643270a9-9807-4791-ade8-5e08ad4681bd
Proved a finite CPT theorem (Conjecture R) for an explicit non-degenerate carrier, all in `RequestProject/Main.lean` (namespace `ConjectureR`). The file builds cleanly with Mathlib only, contains no `sorry`/`admit`/`native_decide`/new `axiom`, and every headline result is kernel-checked with axiom footprint exactly `[propext, Classical.choice, Quot.sound]` (guarded by in-file `#print axioms`).

Carrier: a Clifford ⊗ color witness `H = ℂ⁴` with explicit 4×4 matrices — chiral grading `Gamma = σz⊗I = diag(1,1,-1,-1)`, indefinite fundamental symmetry `Jmet = I⊗σx` (trace 0, `J²=1`, `Jᴴ=J`), Dirac operator `Dop = i·(σx⊗σy)` (chiral-odd `ΓDΓ=-D`, Krein-self-adjoint), Krein adjoint `sharp X = J Xᴴ J`, and the antilinear CPT operator `Theta v = R · conj v` with `R = Gamma·Jmet`, exhibiting `Θ = C ∘ Γrev ∘ #` on the carrier.

Results delivered:
1. `Theta_antiunitary` — `Θ` is antilinear (`Theta_add`, `Theta_smul`) and Krein-isometric (`Theta_krein_isometry`: `⟪Θv,Θw⟫_J = conj⟪v,w⟫_J`).
2. `Theta_conjugates_D_to_sharp` — `Θ` is an involution (`Theta_involutive`, so `Θ⁻¹=Θ`) and `Θ D Θ⁻¹ = D^#`, reduced to the matrix identity `R·conj(D)·R = D^#`.
3. `spectrum_conjugate_paired` — since `D` is Krein-self-adjoint (`sharp_Dop_eq: D^#=D`), `Θ` commutes with `D`; combined with antilinearity and injectivity, `D v = λv, v≠0 ⇒ D(Θv) = conj λ·(Θv), Θv≠0`, i.e. the spectrum is conjugate-paired. The companion fact `Dop_sq: D·D = -1` pins the spectrum to `{i,-i}`.

Supporting reusable matrix lemmas (`Gamma_sq`, `Jmet_sq`, `Jmet_herm`, `Gamma_herm`, `Dop_chiral_odd`, `Rmat_sq`, `Rmat_krein_isom`, `Rmat_conjD_Rmat`, etc.) are all proved by finite computation.

Honest scope (see `ARISTOTLE_SUMMARY.md`): the theorem is established for this concrete `ℂ⁴` Clifford ⊗ color witness, not for arbitrary finite null-edge carriers; `Θ` is modelled directly as an antilinear carrier operator with matrix part `R = Γ·J`; the properties `Θ²=1` and `D^#=D` are computed facts of the chosen operators, not assumptions.

# Conjecture R — a finite CPT theorem

All results live in `RequestProject/Main.lean`, namespace `ConjectureR`. The file
builds cleanly (`lake build RequestProject.Main`) with **no `sorry`, `admit`,
`native_decide`, or new `axiom`**, using Mathlib only. Every headline theorem is
kernel-checked with axiom footprint exactly `[propext, Classical.choice, Quot.sound]`,
guarded in-file by `#print axioms` at the bottom of the file.

## The carrier

The finite null-edge carrier is modelled concretely as the **Clifford ⊗ color
witness** `H = ℂ⁴` (`spin 2 ⊗ color 2`), with explicit `4×4` complex matrices:

| object | definition | role |
|---|---|---|
| `Gamma` | `σz ⊗ I = diag(1,1,-1,-1)` | chiral grading (edge-orientation reversal `Γrev`), `Γ² = 1`, `Γᴴ = Γ` |
| `Jmet` | `I ⊗ σx` | fundamental symmetry / indefinite metric, `J² = 1`, `Jᴴ = J`, trace `0` (genuinely indefinite) |
| `Dop` | `i·(σx ⊗ σy)` | Dirac operator; real antisymmetric, chiral-odd (`Γ D Γ = -D`), Krein-self-adjoint (`D^# = D`) |
| `sharp X` | `J Xᴴ J` | Krein (indefinite-metric) adjoint `X^#` |
| `Rmat` | `Gamma * Jmet` | matrix part of the CPT operator |
| `Theta v` | `Rmat *ᵥ (star v)` | the CPT operator `Θ = C ∘ Γrev ∘ #`, realised on the carrier as the antilinear map `v ↦ R · conj v` |

The construction `R = Γ · J` makes the physical reading explicit: on the carrier
the composite `C · Γrev · #` reduces to complex conjugation `C` composed with the
grading `Γrev` and the metric part `J` of the Krein adjoint `#`. The three
operators `Γ`, `J`, `D` are pairwise distinct and none is a scalar multiple of
another, so the witness is non-degenerate.

## What is proved

### Target 1 — antiunitarity (`Theta_antiunitary`)
`Θ` is antilinear and Krein-isometric:
* `Theta_add`   : `Θ (v + w) = Θ v + Θ w`;
* `Theta_smul`  : `Θ (c • v) = conj c • Θ v`  (antilinearity);
* `Theta_krein_isometry` : `⟪Θ v, Θ w⟫_J = conj ⟪v, w⟫_J`, where
  `kreinForm v w = (star v) ⬝ᵥ (Jmet *ᵥ w)` is the indefinite inner product.

### Target 2 — `Θ D Θ⁻¹ = D^#` (`Theta_conjugates_D_to_sharp`)
`Θ` is an involution (`Theta_involutive : Θ (Θ v) = v`), so `Θ⁻¹ = Θ`, and
`Theta_conjugates_D_to_sharp : Θ (D (Θ v)) = D^# v` for all `v`. This is proved as
a finite operator identity from the definitions of `C` (conjugation), `Γrev`
(grading) and `#` (Krein adjoint), reducing to the matrix identity
`Rmat_conjD_Rmat : R · conj(D) · R = D^#`.

### Target 3 — conjugate pairing of the spectrum (`spectrum_conjugate_paired`)
Because `D` is Krein-self-adjoint (`sharp_Dop_eq : D^# = D`), the CPT operator
commutes with `D` (`Theta_comm_Dop : Θ (D v) = D (Θ v)`). Combined with
antilinearity and injectivity of `Θ` (`Theta_ne_zero`), this yields:
if `D v = λ v` with `v ≠ 0`, then `D (Θ v) = conj λ · (Θ v)` with `Θ v ≠ 0`.
Hence every eigenvalue's complex conjugate is again an eigenvalue — the spectrum
of `D` is conjugate-paired. The adjacent determinant/parity fact
`Dop_sq : D · D = -1` pins the spectrum of this witness to the conjugate pair
`{i, -i}`.

## Honest notes and scope

* The theorem is established **for the concrete `ℂ⁴` Clifford ⊗ color witness
  above**, with the specific `Γ`, `J`, `D` listed. It is a finite CPT theorem for
  this carrier, not a proof of the general conjecture for arbitrary finite
  null-edge carriers.
* `Θ` is modelled directly as an antilinear operator on the carrier (the natural
  home for "antiunitary" and for the conjugation `Θ D Θ⁻¹`); the composite
  `C · Γrev · #` is realised via its matrix part `R = Γ · J`. This choice is
  documented in the file docstring.
* For this witness `Θ² = 1` (`Theta_involutive`) and `D^# = D`
  (`sharp_Dop_eq`); both are genuine computed properties of the chosen operators,
  not assumptions. `D^# = D` is exactly the statement that the Dirac operator is
  Krein-self-adjoint, which is the physically expected property.
* All matrix-level facts (`Gamma_sq`, `Jmet_sq`, `Jmet_herm`, `Gamma_herm`,
  `Dop_chiral_odd`, `Rmat_sq`, `Rmat_krein_isom`, `Rmat_conjD_Rmat`, `Dop_sq`,
  …) are proved by finite computation and are available as reusable lemmas.

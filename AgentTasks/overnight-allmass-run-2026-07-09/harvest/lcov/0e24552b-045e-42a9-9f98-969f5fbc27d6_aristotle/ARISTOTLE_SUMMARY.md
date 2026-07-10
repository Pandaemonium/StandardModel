# Summary of changes for run 0e24552b-045e-42a9-9f98-969f5fbc27d6
Built `RequestProject/Main.lean` (namespace `LambdaTwoRegionCovariance`) — a finite, kernel-checked independent-edge covariance model for everpresent Lambda across two nested causal regions `R1 ⊆ R2`, plus `ARISTOTLE_SUMMARY.md`.

Model (honest, not by fiat): a mean-zero random variable is its coefficient vector on three independent group fluctuations `RV := ℚ×ℚ×ℚ` with basis `dNa, dNb, dNc`; covariance is the count-weighted diagonal form `cov a b c x y = x₁y₁a + x₂₁y₂₁b + x₂₂y₂₂c`. Independence is therefore proved, not assumed: bilinearity (`cov_add_left/right`, `cov_smul_left/right`), symmetry (`cov_symm`), orthogonality of distinct groups (`cov_dNa_dNb`, `cov_dNa_dNc`, `cov_dNb_dNc = 0`), and per-group variance = count (`var_dNa/dNb/dNc`). Here `N1 = dNa+dNb`, `N2 = dNb+dNc`.

Targets delivered:
1. `count_variances`: `Var(N1)=a+b`, `Var(N2)=b+c`, `Cov(N1,N2)=b` (only shared edges correlate); `cov_N1_N2_via_independence` re-derives the cross term as `Cov(X+Y,X+Z)=Var(X)=b` from bilinearity+orthogonality.
2. `lambda_covariance` (payload): with `Λ1=(1/⟨N1⟩)·δN1`, `Λ2=(1/⟨N2⟩)·δN2` and nonzero means, `Cov(Λ1,Λ2)=b/(⟨N1⟩⟨N2⟩)` — set by the shared count.
3. `correlation_length_reading`: `Corr = b/√((a+b)(b+c))` with both limits proved (`corr_comoving`: `a=c=0,b>0 ⟹ 1`; `corr_decoupled`: `b=0 ⟹ 0`); `Real.sqrt` used only here.
4. `distinguisher_verdict`: packages the variances/covariance, Lambda covariance, and both correlation limits.

Mandatory non-degeneracy witnesses with explicit rationals in-theorem: `nested_witness` (a=1,b=98,c=1) gives `Cov(N1,N2)=98`, `Corr=98/99`; `decoupled_witness` (a=50,b=1,c=50) gives `Corr=1/51`.

Compliance: Mathlib only; no `sorry`/`admit`/`native_decide`/new axioms; every headline audited in-file by `#guard_msgs (whitespace := lax) in #print axioms …` showing footprint exactly `[propext, Classical.choice, Quot.sound]`; no Complex/trig/log, no high-degree nlinarith; proofs use ring/norm_num/simp/field_simp and one `Real.sqrt_sq`/`Real.sqrt_mul_self`. Full build succeeds in ~20s. Honest scope (finite independent-edge model; the physical ensemble's real correlations are the open input) is documented in the file docstring and summary. All work committed and pushed.

# claude-lambda-two-region-covariance — summary

A finite, kernel-checked covariance model for the everpresent-Lambda dark-energy
fluctuation between two **nested** causal regions `R1 ⊆ R2`. All results live in
`RequestProject/Main.lean`, namespace `LambdaTwoRegionCovariance`.

## The model (honest, not by fiat)

Edges are split into three **independent** groups by counts: `a` (only in `R1`),
`b` (shared overlap `R1 ∩ R2`), `c` (only in `R2`), with `N1 = a+b`, `N2 = b+c`.

A mean-zero random variable is represented by its coefficient vector on the three
independent fluctuations, `RV := ℚ × ℚ × ℚ`, with basis `dNa, dNb, dNc`. The
covariance is the count-weighted diagonal inner product

```
cov a b c x y = x.1*y.1*a + x.2.1*y.2.1*b + x.2.2*y.2.2*c
```

so that independence (`Var(group) = count`, distinct groups uncorrelated) is a
*proved* property rather than an assumption:

- `cov_add_left` / `cov_add_right` / `cov_smul_left` / `cov_smul_right` — bilinearity;
- `cov_symm` — symmetry;
- `cov_dNa_dNb`, `cov_dNa_dNc`, `cov_dNb_dNc = 0` — orthogonality of distinct groups;
- `var_dNa/dNb/dNc = a/b/c` — each group variance equals its count.

`N1 = dNa + dNb`, `N2 = dNb + dNc`.

## Headline results

1. **`count_variances`**: `Var(N1)=a+b`, `Var(N2)=b+c`, and `Cov(N1,N2)=b` — only
   the shared edges correlate. `cov_N1_N2_via_independence` re-derives the cross
   term as `Cov(dNa+dNb, dNb+dNc) = Var(dNb) = b` purely from bilinearity +
   orthogonality (the `Cov(X+Y,X+Z)=Var(X)` shape).
2. **`lambda_covariance`** (payload): with `Λ1 = (1/⟨N1⟩)·δN1`, `Λ2 = (1/⟨N2⟩)·δN2`
   and nonzero means, `Cov(Λ1,Λ2) = b/(⟨N1⟩⟨N2⟩)` — set by the shared count.
3. **`correlation_length_reading`**: `Corr = b/√((a+b)(b+c))` (`corr`), with the two
   limits proved — `corr_comoving` (`a=c=0`, `b>0` ⟹ `Corr = 1`, horizon-scale) and
   `corr_decoupled` (`b=0` ⟹ `Corr = 0`). `Real.sqrt` appears only on this line.
4. **`distinguisher_verdict`**: packages the variances/covariance, the Lambda
   covariance, and both correlation limits into one falsifiable fingerprint.

## Mandatory non-degeneracy witnesses (explicit rationals)

- `nested_witness` (`a=1, b=98, c=1`): `Cov(N1,N2) = 98` and `Corr = 98/99`.
- `decoupled_witness` (`a=50, b=1, c=50`): `Cov(N1,N2) = 1` and `Corr = 1/51`.

## Compliance

- Kernel-checked: no `sorry`/`admit`/`native_decide`, no new axioms. Mathlib only.
- Footprint exactly `[propext, Classical.choice, Quot.sound]`, audited in-file by
  `#guard_msgs (whitespace := lax) in #print axioms <thm>` on every headline.
- No `Complex`, no `Real.cos/sin/log`, no high-degree `nlinarith`; proofs use
  `ring`/`norm_num`/`simp`/`field_simp` and one `Real.sqrt_sq`/`Real.sqrt_mul_self`.
- Builds in ~20s.

## Honest scope

A finite independent-edge covariance model. The physical ensemble's actual
correlations — Poisson vs. hyperuniform per the dichotomy — are the open input;
no claim is made about the real dark-energy power spectrum.

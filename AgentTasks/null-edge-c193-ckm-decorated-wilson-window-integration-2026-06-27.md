# C193 integration note: CKM-decorated Wilson mass window

Date: 2026-06-27

Aristotle project: `e63bde80-6cec-4422-a350-0189a78037dc`
Aristotle task: `0678f49b-4230-465f-94fa-4c0210598cdd`

## Result

C193 returned a standalone Lean theorem package for the free
Wilson/Neuberger+CKM reference mass window.

Returned artifact:

```text
AgentTasks/aristotle-output/e63bde80-6cec-4422-a350-0189a78037dc/extracted/0678f49b-4230-465f-94fa-4c0210598cdd_aristotle/RequestProject/Main.lean
```

## Mathematical content

The model uses sector labels `(n, ell)` with:

```text
n = spacetime momentum-corner count;
ell = CKM finite branch/flavor level.
```

The shifted mass is:

```text
mu(n, ell) = 2 r_W n + w(ell) - m0.
```

The CKM weight is:

```text
w(0) = 0;
w(ell > 0) = 16 r_b.
```

The free margin is:

```text
gamma_free = min(m0, 2 r_W - m0, 16 r_b - m0).
```

Under:

```text
r_W > 0;
0 < m0 < min(2 r_W, 16 r_b),
```

the returned theorem package proves:

```text
mu(0,0) < 0;
mu(n,0) > 0 for n >= 1;
mu(n,ell) > 0 for ell > 0;
mu(n,ell) < 0 iff (n,ell) = (0,0);
gamma_free > 0;
mu(0,0) <= -gamma_free;
mu(n,ell) >= gamma_free for every non-physical sector;
exactly one sector is light over n in {0,1,2,3} and ell in {0,...,15}.
```

## Returned Lean declarations

```text
w;
w_zero;
w_pos_of_pos;
mu;
gamma_free;
gamma_free_pos;
mu_phys_neg;
mu_doubler_pos;
mu_heavy_pos;
mu_neg_iff;
mu_phys_le_neg_margin;
mu_heavy_ge_margin;
light_sector_count;
gateC1_free_mass_window.
```

## Integration decision

This result is integrated into the planning docs as the completed free reference
sign-window certificate.

It is not yet promoted into `PhysicsSM` Lean modules because this cycle did not
run local Lean checks. Promotion should be a separate small task:

```text
1. Copy the theorem package into a draft module.
2. Adjust namespace/import conventions.
3. Run the targeted Lean check.
4. Decide whether to keep it as draft or promote it into a trusted theorem file.
```

## Status impact

Resolved externally:

```text
C193 free Wilson+CKM sign-window theorem.
```

Still open:

```text
actual null-edge Wilsonized kinetic operator;
kappa bound below gamma_free;
sector-signature map S;
SMActsInternally audit;
overlap reference certificates;
anomaly, determinant-line, Krein, and ghost audits;
local promotion/checking of the returned Lean source.
```

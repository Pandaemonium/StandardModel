# C193 Aristotle task: CKM-decorated Wilson mass window

Date: 2026-06-27

Purpose: prove the combined free mass-window theorem for the Wilson/Neuberger spacetime resolver plus CKM branch/flavor texture.

```yaml
aristotle:
  project_id: e63bde80-6cec-4422-a350-0189a78037dc
  task_id: 0678f49b-4230-465f-94fa-4c0210598cdd
  target_file: none
  expected_module: none
  submission_project: prompt-only
  prompt_file: AgentTasks\aristotle-prompts\gate-c1-ckm-decorated-wilson-window-c193.prompt.md
  output_dir: AgentTasks/aristotle-output/e63bde80-6cec-4422-a350-0189a78037dc
  status: integrated
```

## Requested result

Prove that for:

```text
mu(n, ell) = 2*r_W*n + w(ell) - m0,
w(0)=0,
w(ell>0)=16*r_b,
```

if:

```text
0 < m0 < min(2*r_W, 16*r_b),
```

then exactly (n=0, ell=0) is negative/light and all spacetime doublers or CKM-heavy sectors are positive/heavy, with margin min(m0, 2*r_W-m0, 16*r_b-m0).

## Integration status

Integrated into docs and preserved as an Aristotle artifact.

Returned Lean artifact:

```text
AgentTasks/aristotle-output/e63bde80-6cec-4422-a350-0189a78037dc/extracted/0678f49b-4230-465f-94fa-4c0210598cdd_aristotle/RequestProject/Main.lean
```

Returned theorem package:

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

Summary:

```text
C193 proves the free reference sign-window certificate for the
CKM-decorated Wilson/Neuberger kernel. The only light sector is (0,0);
all spacetime doublers and CKM-heavy sectors are heavy; the uniform margin is
gamma_free = min(m0, 2*r_W-m0, 16*r_b-m0).
```

Local verification:

```text
Not run in this integration cycle. The result remains an external Aristotle
artifact until locally promoted and checked.
```

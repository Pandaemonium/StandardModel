---
project_id: 63804683-60db-4338-851c-416759aa4df2
task_id: 42dc4722-5453-4690-a0d2-66aec21c2f6f
status: integrated
created: 2026-06-27
round: gate-c1-reference-match
---

# Aristotle C156: range-k/path-shell Neumann locality theorem

Goal: Prove the next finite locality theorem suggested by C151: finite propagation of powers plus summable coefficients implies path-shell control.

Context: C151 linked HJL locality to null-edge path-shell summability and identified the smallest next theorem: a finite geometric/Neumann range-k shell bound. C143 already proves oddness survives when shell tails are summable and dominated.

Requested deliverables:

1. Formalize a graph/operator setting where `H` has finite propagation range or shell growth control.
2. Prove that powers `H^n` are supported in distance at most `n*r` or satisfy a shell-count bound.
3. Combine with summable coefficients for a Neumann/Chebyshev/sign approximation to get controlled row sums.
4. State how this supplies the null-edge analogue of HJL locality without ultralocality.
5. Include failure modes: exponential graph growth without enough amplitude decay, nonuniform tails, or loss of gap.

Success criterion: a formal or theorem-design bridge from finite-range kernel pieces to the path-shell locality certificate.

## Submission status

Submitted on 2026-06-27. Project: 63804683-60db-4338-851c-416759aa4df2. Task: .

## Completion integration

Integrated on 2026-06-27.

Project: 63804683-60db-4338-851c-416759aa4df2
Task: 42dc4722-5453-4690-a0d2-66aec21c2f6f
Artifact archive: AgentTasks/aristotle-output/63804683-60db-4338-851c-416759aa4df2/project.zip
Report/design note: $(System.Collections.Hashtable.Report)

Summary: Path-shell locality theorem: finite propagation plus summable coefficients gives uniform far-field control.

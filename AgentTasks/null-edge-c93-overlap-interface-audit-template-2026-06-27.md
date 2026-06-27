# C93 overlap/Ginsparg-Wilson interface audit template

Use this before integrating any returned `NullEdgeOverlapC1Interface.lean`
module.

Claude review log:

```text
AgentTasks/model-calls/claude/2026-06-27-101543-c1-route-c93-review-utf8.md
```

## Required classification

For each C93 declaration, classify it as:

```text
definition
theorem
hypothesis field
guardrail theorem
literature warning predicate
release predicate
```

Do not promote C93 as C1 progress unless at least one declaration does more than
define an interface. A well-designed interface is useful, but it is not release.

## Non-vacuity checks

Check whether the returned module includes these ideas, either verbatim or under
equivalent names:

```text
OverlapC1Interface.is_interface_only
OverlapC1Interface.not_a_release_certificate
OverlapC1Interface.requires_index_witness
OverlapC1Interface.requires_anti_vectorialization
OverlapC1Interface.kernel_gap_is_hypothesis_not_theorem
C0_does_not_imply_C93
C93_does_not_imply_C1Release
GW_relation_alone_is_vacuous_without_index
single_surface_domain_wall_vectorialization_warning
ghost_zero_pressure_warning
```

If these are missing, record whether they are absent because Aristotle proved a
better equivalent statement or because the output is too weak.

## Minimum C93 fields

Audit the interface for:

```text
D
Gamma_GW
mu
gw_relation
Gamma_hat or modified chirality
kernel_gap as hypothesis
index slot or index functional
anti_vectorialization side condition
non-C0 implication guardrail
non-release guardrail
```

## Hard fail conditions

Treat the output as unsafe if it:

- names the interface as C1 release;
- treats GW relation alone as release;
- omits an index/nontriviality slot;
- hides the kernel gap as already proved;
- allows C0 species health to imply C1;
- conflates `Gamma_s`, `chi_E`, and the GW chirality operator;
- ignores the domain-wall vectorialization warning.

## Next-job decision

If C93 is a clean interface:

```text
submit C94-instantiation:
  Attempt to populate OverlapC1Interface from the C89 RA-Wilson operator and
  report the first missing field or contradiction.
```

If C93 is too weak:

```text
submit C93-hardening:
  Add non-release, non-C0-implication, index-slot, kernel-gap-hypothesis, and
  anti-vectorialization guardrails.
```

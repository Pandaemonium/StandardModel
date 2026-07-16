"""Stage A39 intrinsic mesoscopic-algebra and operator-locality audit.

The candidate algebra is the degree-two envelope of a rank-four generator
subspace,

    A2 = span{1, V, Sym^2 V}.

Only its projector matters: internal affine or GL(4) changes of generators are
gauge changes.  The graph-side candidate uses the simultaneous Johnston
embedding reconstructed from causal order and interval counts.  Dimension,
density, interval endpoints, duration, and spatial rank remain supplied.

The diagnostics test product, operator, and corrected-product-defect closure,
plus restricted double and triple multiplication commutators.  They are
finite external numerical controls, not a continuum theorem or a derivation
of a function algebra from a completely bare order.
"""

from __future__ import annotations

import argparse
import json
from dataclasses import asdict, dataclass
from pathlib import Path

import numpy as np

from causal_intrinsic_probe_metric import (
    causal_relation_matrix,
    full_project_smeared_operator,
)
from causal_johnston_full_embedding import (
    all_open_interval_counts,
    johnston_full_embedding_from_relation,
)
from causal_johnston_probe_metric import (
    causal_interval_points,
    minkowski_interval_coefficient,
)
from causal_operator_metric import signature
from causal_operator_weak_geometry import potential_free_operator


DIAGNOSTIC_NAMES = (
    "operator_closure_defect",
    "gamma_closure_defect",
    "double_multiplication_defect",
    "triple_commutator_defect",
)


@dataclass(frozen=True)
class GeneratorAlgebra:
    generator_basis: np.ndarray
    envelope_basis: np.ndarray
    generator_rank: int
    envelope_rank: int
    generator_condition: float
    envelope_condition: float


@dataclass(frozen=True)
class AlgebraDiagnostics:
    sector: str
    events: int
    evaluation_count: int
    generator_rank: int
    envelope_rank: int
    generator_condition: float
    envelope_condition: float
    generator_product_closure_defect: float
    envelope_product_closure_defect: float
    operator_closure_defect: float
    gamma_closure_defect: float
    double_multiplication_defect: float
    triple_commutator_defect: float
    mean_pairing_signature: tuple[int, int, int]
    eventwise_lorentzian_fraction: float
    determinant_volume_coefficient_of_variation: float | None
    gl_envelope_projector_error: float


@dataclass(frozen=True)
class BaseCausalSample:
    points: np.ndarray
    relation: np.ndarray
    interval_counts: np.ndarray
    density: float
    ell: float
    bottom_index: int
    top_index: int


def order_depth_region(
    relation: np.ndarray,
    retained_fraction: float,
    minimum_events: int = 30,
) -> np.ndarray:
    """Select a relabeling-covariant central region from two-sided depth."""

    if relation.ndim != 2 or relation.shape[0] != relation.shape[1]:
        raise ValueError("relation must be square")
    if not 0.0 < retained_fraction <= 1.0:
        raise ValueError("retained fraction must lie in (0, 1]")
    if minimum_events <= 0 or minimum_events > len(relation):
        raise ValueError("minimum events must lie in the carrier range")

    past = np.count_nonzero(relation, axis=0)
    future = np.count_nonzero(relation, axis=1)
    depth = np.minimum(past, future)
    requested = max(minimum_events, int(np.ceil(retained_fraction * len(relation))))
    requested = min(requested, len(relation))
    threshold = np.partition(depth, len(depth) - requested)[len(depth) - requested]
    return depth >= threshold


def _orthonormal_fields(
    fields: np.ndarray,
    evaluation_mask: np.ndarray,
    relative_tolerance: float = 1.0e-10,
) -> tuple[np.ndarray, int, float]:
    values = np.asarray(fields, dtype=float)
    if values.ndim != 2 or values.shape[0] != len(evaluation_mask):
        raise ValueError("fields must have one row per event")
    restricted = values[evaluation_mask]
    _, singular_values, right_transpose = np.linalg.svd(
        restricted, full_matrices=False
    )
    if len(singular_values) == 0 or singular_values[0] <= 0.0:
        return np.empty((len(values), 0)), 0, float("inf")
    keep = singular_values > relative_tolerance * singular_values[0]
    rank = int(np.count_nonzero(keep))
    if rank == 0:
        return np.empty((len(values), 0)), 0, float("inf")
    transform = right_transpose[keep].T / singular_values[keep][None, :]
    basis = values @ transform
    condition = float(singular_values[0] / singular_values[keep][-1])
    return basis, rank, condition


def _symmetric_products(fields: np.ndarray) -> np.ndarray:
    columns = [
        fields[:, left] * fields[:, right]
        for left in range(fields.shape[1])
        for right in range(left, fields.shape[1])
    ]
    if not columns:
        return np.empty((len(fields), 0))
    return np.column_stack(columns)


def degree_two_generator_algebra(
    coordinates: np.ndarray,
    evaluation_mask: np.ndarray,
) -> GeneratorAlgebra:
    """Construct a basis gauge for ``span{1,V,Sym^2 V}``."""

    values = np.asarray(coordinates, dtype=float)
    if values.ndim != 2 or values.shape[0] != len(evaluation_mask):
        raise ValueError("coordinates must have one row per event")
    centered = values - np.mean(values[evaluation_mask], axis=0)
    generators, generator_rank, generator_condition = _orthonormal_fields(
        centered, evaluation_mask
    )
    raw_envelope = np.column_stack(
        (
            np.ones(len(values)),
            generators,
            _symmetric_products(generators),
        )
    )
    envelope, envelope_rank, envelope_condition = _orthonormal_fields(
        raw_envelope, evaluation_mask
    )
    return GeneratorAlgebra(
        generator_basis=generators,
        envelope_basis=envelope,
        generator_rank=generator_rank,
        envelope_rank=envelope_rank,
        generator_condition=generator_condition,
        envelope_condition=envelope_condition,
    )


def _projection_defect(
    basis: np.ndarray,
    fields: np.ndarray,
    evaluation_mask: np.ndarray,
) -> float:
    values = np.asarray(fields, dtype=float)
    if values.ndim == 1:
        values = values[:, None]
    restricted_basis = basis[evaluation_mask]
    restricted_values = values[evaluation_mask]
    fitted = restricted_basis @ (restricted_basis.T @ restricted_values)
    denominator = float(np.linalg.norm(restricted_values, ord="fro"))
    residual = float(np.linalg.norm(restricted_values - fitted, ord="fro"))
    if denominator <= 1.0e-14:
        return 0.0 if residual <= 1.0e-14 else float("inf")
    return residual / denominator


def _fixed_gl_transform(dimension: int) -> tuple[np.ndarray, np.ndarray]:
    linear = np.eye(dimension)
    for row in range(dimension):
        for column in range(dimension):
            if row != column:
                linear[row, column] = 0.03 * (row + 1) / (column + 1)
    offset = np.linspace(-0.4, 0.3, dimension)
    return linear, offset


def gl_envelope_projector_error(
    coordinates: np.ndarray,
    evaluation_mask: np.ndarray,
    original: GeneratorAlgebra,
) -> float:
    """Compare degree-two projectors after a fixed affine GL change."""

    linear, offset = _fixed_gl_transform(coordinates.shape[1])
    transformed = coordinates @ linear.T + offset
    transformed_algebra = degree_two_generator_algebra(
        transformed, evaluation_mask
    )
    left = original.envelope_basis[evaluation_mask]
    right = transformed_algebra.envelope_basis[evaluation_mask]
    left_projector = left @ left.T
    right_projector = right @ right.T
    denominator = max(1.0, float(np.linalg.norm(left_projector, ord="fro")))
    return float(
        np.linalg.norm(left_projector - right_projector, ord="fro") / denominator
    )


def _commutator_geometry(
    box: np.ndarray,
    generators: np.ndarray,
    evaluation_mask: np.ndarray,
) -> tuple[np.ndarray, float, float]:
    """Return Gamma fields and restricted double/triple defects.

    For multiplication fields ``f`` and ``h``, the exact finite kernel is

        [[B,M_f],M_h]_ij = B_ij (f_j-f_i)(h_j-h_i).

    This avoids constructing nested dense commutators.
    """

    event_count, generator_count = generators.shape
    constant = np.ones((event_count, 1))
    test_fields = np.column_stack((constant, generators))
    test_count = test_fields.shape[1]
    multiplied_tests = [
        generators[:, index, None] * test_fields
        for index in range(generator_count)
    ]
    all_inputs = np.column_stack((test_fields, *multiplied_tests))

    gamma = np.empty((event_count, generator_count, generator_count), dtype=float)
    double_actual: list[np.ndarray] = []
    double_expected: list[np.ndarray] = []
    triple_values: list[np.ndarray] = []
    triple_references: list[np.ndarray] = []

    for left in range(generator_count):
        left_delta = (
            generators[:, left][None, :] - generators[:, left][:, None]
        )
        for right in range(generator_count):
            right_delta = (
                generators[:, right][None, :]
                - generators[:, right][:, None]
            )
            double_kernel = box * left_delta * right_delta
            actions = double_kernel @ all_inputs
            base_action = actions[:, :test_count]
            gamma_field = 0.5 * (double_kernel @ np.ones(event_count))
            gamma[:, left, right] = gamma_field
            expected = 2.0 * gamma_field[:, None] * test_fields
            double_actual.append(base_action[evaluation_mask])
            double_expected.append(expected[evaluation_mask])

            for third in range(generator_count):
                start = test_count * (third + 1)
                stop = start + test_count
                acted_product = actions[:, start:stop]
                multiplied_action = generators[:, third, None] * base_action
                triple_values.append(
                    (acted_product - multiplied_action)[evaluation_mask]
                )
                triple_references.extend(
                    [
                        acted_product[evaluation_mask],
                        multiplied_action[evaluation_mask],
                    ]
                )

    actual_stack = np.concatenate(double_actual, axis=1)
    expected_stack = np.concatenate(double_expected, axis=1)
    double_denominator = max(
        1.0e-14,
        float(np.linalg.norm(actual_stack, ord="fro")),
        float(np.linalg.norm(expected_stack, ord="fro")),
    )
    double_defect = float(
        np.linalg.norm(actual_stack - expected_stack, ord="fro")
        / double_denominator
    )
    triple_stack = np.concatenate(triple_values, axis=1)
    reference_norm_sq = sum(
        float(np.linalg.norm(value, ord="fro")) ** 2
        for value in triple_references
    )
    triple_denominator = max(1.0e-14, np.sqrt(reference_norm_sq))
    triple_defect = float(
        np.linalg.norm(triple_stack, ord="fro") / triple_denominator
    )
    return gamma, double_defect, triple_defect


def evaluate_algebra(
    sector: str,
    coordinates: np.ndarray,
    operator: np.ndarray,
    evaluation_mask: np.ndarray,
) -> AlgebraDiagnostics:
    """Evaluate one generator sector against a fixed causal operator."""

    algebra = degree_two_generator_algebra(coordinates, evaluation_mask)
    generators = algebra.generator_basis
    envelope = algebra.envelope_basis
    generator_products = _symmetric_products(generators)
    envelope_products = _symmetric_products(envelope)
    box = potential_free_operator(operator)

    generator_product_defect = _projection_defect(
        envelope, generator_products, evaluation_mask
    )
    envelope_product_defect = _projection_defect(
        envelope, envelope_products, evaluation_mask
    )
    operator_defect = _projection_defect(
        envelope, box @ envelope, evaluation_mask
    )
    gamma, double_defect, triple_defect = _commutator_geometry(
        box, generators, evaluation_mask
    )
    gamma_fields = gamma.reshape(len(gamma), -1)
    gamma_defect = _projection_defect(
        envelope, gamma_fields, evaluation_mask
    )

    event_metrics = 0.5 * (
        gamma[evaluation_mask]
        + np.swapaxes(gamma[evaluation_mask], 1, 2)
    )
    mean_metric = np.mean(event_metrics, axis=0)
    eigenvalues = np.linalg.eigvalsh(event_metrics)
    scales = np.maximum(1.0, np.max(np.abs(eigenvalues), axis=1))
    thresholds = 1.0e-8 * scales
    positive = np.sum(eigenvalues > thresholds[:, None], axis=1)
    negative = np.sum(eigenvalues < -thresholds[:, None], axis=1)
    lorentzian = (positive == 1) & (negative == 3)
    lorentzian_fraction = float(np.mean(lorentzian))

    volume_variation = None
    if np.count_nonzero(lorentzian) >= 2:
        determinants = np.linalg.det(event_metrics[lorentzian])
        volumes = 1.0 / np.sqrt(np.abs(determinants))
        mean_volume = float(np.mean(volumes))
        if np.isfinite(mean_volume) and mean_volume > 0.0:
            volume_variation = float(np.std(volumes) / mean_volume)

    return AlgebraDiagnostics(
        sector=sector,
        events=len(operator),
        evaluation_count=int(np.count_nonzero(evaluation_mask)),
        generator_rank=algebra.generator_rank,
        envelope_rank=algebra.envelope_rank,
        generator_condition=algebra.generator_condition,
        envelope_condition=algebra.envelope_condition,
        generator_product_closure_defect=generator_product_defect,
        envelope_product_closure_defect=envelope_product_defect,
        operator_closure_defect=operator_defect,
        gamma_closure_defect=gamma_defect,
        double_multiplication_defect=double_defect,
        triple_commutator_defect=triple_defect,
        mean_pairing_signature=signature(mean_metric),
        eventwise_lorentzian_fraction=lorentzian_fraction,
        determinant_volume_coefficient_of_variation=volume_variation,
        gl_envelope_projector_error=gl_envelope_projector_error(
            coordinates, evaluation_mask, algebra
        ),
    )


def construct_base_sample(
    rng: np.random.Generator,
    events: int,
    duration: float,
    dimension: int,
    block_size: int,
) -> BaseCausalSample:
    points, bottom_index, top_index = causal_interval_points(
        rng, events, duration
    )
    relation = causal_relation_matrix(points, block_size)
    interval_counts = all_open_interval_counts(relation)
    interval_volume = minkowski_interval_coefficient(dimension) * duration**dimension
    density = events / interval_volume
    ell = (interval_volume / events) ** (1.0 / dimension)
    return BaseCausalSample(
        points=points,
        relation=relation,
        interval_counts=interval_counts,
        density=density,
        ell=ell,
        bottom_index=bottom_index,
        top_index=top_index,
    )


def operator_for_setting(
    sample: BaseCausalSample,
    duration: float,
    nonlocality_multiplier: float,
) -> tuple[np.ndarray, float]:
    if nonlocality_multiplier <= 0.0:
        raise ValueError("nonlocality multiplier must be positive")
    nonlocality_scale = nonlocality_multiplier * np.sqrt(sample.ell * duration)
    if nonlocality_scale <= sample.ell:
        raise ValueError("nonlocality scale must exceed the discreteness scale")
    operator = full_project_smeared_operator(
        sample.relation,
        sample.ell,
        nonlocality_scale,
        sample.interval_counts,
    )
    return operator, float(nonlocality_scale)


def johnston_coordinates(
    sample: BaseCausalSample,
    duration: float,
    dimension: int,
) -> np.ndarray:
    embedding = johnston_full_embedding_from_relation(
        sample.relation,
        sample.density,
        dimension,
        sample.bottom_index,
        sample.top_index,
        duration,
        spatial_rank=dimension - 1,
    )
    return embedding.coordinates


def random_coordinates(
    rng: np.random.Generator,
    event_count: int,
    dimension: int,
) -> np.ndarray:
    return rng.normal(size=(event_count, dimension))


def _median(values: list[float]) -> float:
    return float(np.median(np.asarray(values, dtype=float)))


def summarize_diagnostics(
    samples: list[AlgebraDiagnostics],
) -> dict[str, object]:
    if not samples:
        raise ValueError("cannot summarize an empty sample list")
    result: dict[str, object] = {
        "sample_count": len(samples),
        "evaluation_count_median": _median(
            [float(sample.evaluation_count) for sample in samples]
        ),
        "rank_15_rate": sum(sample.envelope_rank == 15 for sample in samples)
        / len(samples),
        "mean_lorentzian_rate": sum(
            sample.mean_pairing_signature == (1, 3, 0) for sample in samples
        )
        / len(samples),
        "eventwise_lorentzian_fraction_median": _median(
            [sample.eventwise_lorentzian_fraction for sample in samples]
        ),
        "generator_product_closure_defect_median": _median(
            [sample.generator_product_closure_defect for sample in samples]
        ),
        "envelope_product_closure_defect_median": _median(
            [sample.envelope_product_closure_defect for sample in samples]
        ),
        "gl_envelope_projector_error_max": max(
            sample.gl_envelope_projector_error for sample in samples
        ),
    }
    for name in DIAGNOSTIC_NAMES:
        result[f"{name}_median"] = _median(
            [float(getattr(sample, name)) for sample in samples]
        )
    finite_volumes = [
        sample.determinant_volume_coefficient_of_variation
        for sample in samples
        if sample.determinant_volume_coefficient_of_variation is not None
        and np.isfinite(sample.determinant_volume_coefficient_of_variation)
    ]
    result["determinant_volume_cv_median"] = (
        None if not finite_volumes else _median(finite_volumes)
    )
    return result


def _setting_key(nonlocality_multiplier: float, retained_fraction: float) -> str:
    return f"cL={nonlocality_multiplier:.6f}|fraction={retained_fraction:.6f}"


def run_development(args: argparse.Namespace) -> dict[str, object]:
    seed_sequence = np.random.SeedSequence(args.seed)
    base_seeds = seed_sequence.spawn(len(args.events) * args.realizations)
    bases: dict[tuple[int, int], BaseCausalSample] = {}
    seed_index = 0
    for events in args.events:
        for realization in range(args.realizations):
            bases[(events, realization)] = construct_base_sample(
                np.random.default_rng(base_seeds[seed_index]),
                events,
                args.duration,
                args.dimension,
                args.block_size,
            )
            seed_index += 1

    settings: dict[str, object] = {}
    for c_l in args.nonlocality_multipliers:
        operators = {
            key: operator_for_setting(base, args.duration, c_l)[0]
            for key, base in bases.items()
        }
        for fraction in args.retained_fractions:
            by_density: dict[str, object] = {}
            all_samples: list[AlgebraDiagnostics] = []
            for events in args.events:
                density_samples = []
                for realization in range(args.realizations):
                    base = bases[(events, realization)]
                    mask = order_depth_region(
                        base.relation, fraction, args.minimum_evaluation_events
                    )
                    density_samples.append(
                        evaluate_algebra(
                            "oracle",
                            base.points,
                            operators[(events, realization)],
                            mask,
                        )
                    )
                all_samples.extend(density_samples)
                by_density[str(events)] = {
                    "summary": summarize_diagnostics(density_samples),
                    "samples": [asdict(sample) for sample in density_samples],
                }
            structural = all(
                sample.envelope_rank == 15
                and sample.mean_pairing_signature == (1, 3, 0)
                and sample.evaluation_count >= args.minimum_evaluation_events
                for sample in all_samples
            )
            worst = max(
                float(by_density[str(events)]["summary"][f"{name}_median"])
                for events in args.events
                for name in DIAGNOSTIC_NAMES
            )
            key = _setting_key(c_l, fraction)
            settings[key] = {
                "nonlocality_multiplier": c_l,
                "retained_fraction": fraction,
                "structural_pass": structural,
                "worst_closure_locality_median": worst,
                "by_density": by_density,
            }

    selected_key = min(
        settings,
        key=lambda key: (
            not bool(settings[key]["structural_pass"]),
            float(settings[key]["worst_closure_locality_median"]),
            float(settings[key]["nonlocality_multiplier"]),
            float(settings[key]["retained_fraction"]),
        ),
    )
    return {
        "status": "oracle-only A39 development selection; no Johnston result opened",
        "phase": "development",
        "calibration": {
            "seed": args.seed,
            "events": args.events,
            "realizations": args.realizations,
            "duration": args.duration,
            "dimension": args.dimension,
            "nonlocality_schedule": "L = cL * sqrt(ell * T)",
            "minimum_evaluation_events": args.minimum_evaluation_events,
            "nonlocality_multipliers": args.nonlocality_multipliers,
            "retained_fractions": args.retained_fractions,
        },
        "selected_setting": selected_key,
        "selection": settings[selected_key],
        "settings": settings,
    }


def _load_selected_setting(path: Path) -> tuple[float, float, int]:
    payload = json.loads(path.read_text(encoding="utf-8"))
    if payload.get("phase") != "development":
        raise ValueError("development artifact has the wrong phase")
    selection = payload["selection"]
    seed = int(payload["calibration"]["seed"])
    return (
        float(selection["nonlocality_multiplier"]),
        float(selection["retained_fraction"]),
        seed,
    )


def _heldout_pass_summary(
    summaries: dict[str, dict[str, dict[str, object]]],
    low_events: int,
    high_events: int,
) -> dict[str, object]:
    oracle_low = summaries["oracle"][str(low_events)]
    oracle_high = summaries["oracle"][str(high_events)]
    johnston_low = summaries["johnston"][str(low_events)]
    johnston_high = summaries["johnston"][str(high_events)]
    random_high = summaries["random"][str(high_events)]

    structural_pass = all(
        summaries[sector][str(events)]["rank_15_rate"] == 1.0
        and summaries[sector][str(events)][
            "generator_product_closure_defect_median"
        ]
        < 1.0e-10
        and summaries[sector][str(events)]["gl_envelope_projector_error_max"]
        < 1.0e-10
        for sector in ("oracle", "johnston")
        for events in (low_events, high_events)
    )
    oracle_refinement = all(
        float(oracle_high[f"{name}_median"])
        <= float(oracle_low[f"{name}_median"])
        for name in DIAGNOSTIC_NAMES
    )
    oracle_pass = (
        oracle_low["mean_lorentzian_rate"] == 1.0
        and oracle_high["mean_lorentzian_rate"] == 1.0
        and oracle_refinement
    )
    johnston_signature_pass = (
        float(johnston_low["mean_lorentzian_rate"]) >= 0.75
        and float(johnston_high["mean_lorentzian_rate"]) >= 0.75
        and float(johnston_high["eventwise_lorentzian_fraction_median"])
        >= float(johnston_low["eventwise_lorentzian_fraction_median"])
    )
    johnston_beats_random = all(
        float(johnston_high[f"{name}_median"])
        < float(random_high[f"{name}_median"])
        for name in DIAGNOSTIC_NAMES
    )
    improvement_count = sum(
        float(johnston_high[f"{name}_median"])
        < float(johnston_low[f"{name}_median"])
        for name in DIAGNOSTIC_NAMES
    )
    high_threshold_pass = all(
        float(johnston_high[f"{name}_median"]) < 0.75
        for name in DIAGNOSTIC_NAMES
    )
    johnston_refinement_pass = improvement_count >= 3 and high_threshold_pass
    return {
        "structural_pass": structural_pass,
        "oracle_refinement_pass": oracle_refinement,
        "oracle_control_pass": oracle_pass,
        "johnston_signature_pass": johnston_signature_pass,
        "johnston_beats_random_pass": johnston_beats_random,
        "johnston_improving_diagnostic_count": improvement_count,
        "johnston_high_density_threshold_pass": high_threshold_pass,
        "johnston_refinement_pass": johnston_refinement_pass,
        "heldout_pass": bool(
            structural_pass
            and oracle_pass
            and johnston_signature_pass
            and johnston_beats_random
            and johnston_refinement_pass
        ),
    }


def run_heldout(args: argparse.Namespace) -> dict[str, object]:
    if args.development_artifact is None:
        raise ValueError("heldout phase requires --development-artifact")
    c_l, fraction, development_seed = _load_selected_setting(
        args.development_artifact
    )
    if args.seed == development_seed:
        raise ValueError("heldout seed must differ from the development seed")
    if len(args.events) != 2:
        raise ValueError("heldout pass logic requires exactly two densities")

    seed_sequence = np.random.SeedSequence(args.seed)
    base_seeds = seed_sequence.spawn(len(args.events) * args.realizations)
    raw: dict[str, dict[str, list[AlgebraDiagnostics]]] = {
        sector: {str(events): [] for events in args.events}
        for sector in ("oracle", "johnston", "random")
    }
    seed_index = 0
    for events in args.events:
        for realization in range(args.realizations):
            base = construct_base_sample(
                np.random.default_rng(base_seeds[seed_index]),
                events,
                args.duration,
                args.dimension,
                args.block_size,
            )
            operator, _ = operator_for_setting(base, args.duration, c_l)
            mask = order_depth_region(
                base.relation, fraction, args.minimum_evaluation_events
            )
            johnston = johnston_coordinates(base, args.duration, args.dimension)
            random_rng = np.random.default_rng(
                np.random.SeedSequence([args.seed, events, realization, 39])
            )
            sectors = {
                "oracle": base.points,
                "johnston": johnston,
                "random": random_coordinates(
                    random_rng, events, args.dimension
                ),
            }
            for sector, coordinates in sectors.items():
                raw[sector][str(events)].append(
                    evaluate_algebra(sector, coordinates, operator, mask)
                )
            seed_index += 1

    summaries = {
        sector: {
            str(events): summarize_diagnostics(raw[sector][str(events)])
            for events in args.events
        }
        for sector in raw
    }
    pass_summary = _heldout_pass_summary(
        summaries, min(args.events), max(args.events)
    )
    return {
        "status": "conditional order-derived A39 algebra audit; not convergence",
        "phase": "heldout",
        "calibration": {
            "seed": args.seed,
            "development_seed": development_seed,
            "events": args.events,
            "realizations": args.realizations,
            "duration": args.duration,
            "dimension": args.dimension,
            "nonlocality_multiplier": c_l,
            "retained_fraction": fraction,
            "minimum_evaluation_events": args.minimum_evaluation_events,
            "supplied_inputs": [
                "dimension",
                "density",
                "interval endpoints",
                "duration",
                "spatial rank",
                "operator coefficient family",
            ],
        },
        "summaries": summaries,
        "pass_summary": pass_summary,
        "samples": {
            sector: {
                events: [asdict(sample) for sample in samples]
                for events, samples in by_density.items()
            }
            for sector, by_density in raw.items()
        },
    }


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--phase", choices=("development", "heldout"), required=True)
    parser.add_argument("--events", type=int, nargs="+", default=[300, 600])
    parser.add_argument("--realizations", type=int, default=2)
    parser.add_argument("--duration", type=float, default=2.0)
    parser.add_argument("--dimension", type=int, default=4)
    parser.add_argument("--block-size", type=int, default=256)
    parser.add_argument("--minimum-evaluation-events", type=int, default=30)
    parser.add_argument(
        "--nonlocality-multipliers", type=float, nargs="+", default=[0.45, 0.60, 0.75]
    )
    parser.add_argument(
        "--retained-fractions", type=float, nargs="+", default=[0.15, 0.25, 0.35]
    )
    parser.add_argument("--seed", type=int, required=True)
    parser.add_argument("--development-artifact", type=Path)
    parser.add_argument("--output", type=Path, required=True)
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    if args.realizations <= 0:
        raise ValueError("realizations must be positive")
    if args.dimension != 4:
        raise ValueError("this benchmark is convention-locked to dimension four")
    if args.phase == "development":
        result = run_development(args)
    else:
        result = run_heldout(args)
    args.output.write_text(
        json.dumps(result, indent=2) + "\n",
        encoding="utf-8",
        newline="\n",
    )


if __name__ == "__main__":
    main()

use core::num::traits::{One, Zero};
use stwo_constraint_framework::{
    LookupElements, PreprocessedColumnSet, PreprocessedMaskValues, PreprocessedMaskValuesImpl,
};
use stwo_verifier_core::circle::CirclePoint;
use stwo_verifier_core::fields::m31::M31Trait;
use stwo_verifier_core::fields::qm31::{QM31, QM31Trait};

pub fn dummy_lookup_elements<const N: usize>() -> LookupElements<N> {
    let mut alpha_powers = array![];
    let mut index = 0_usize;
    while index < N {
        alpha_powers.append(One::one());
        index += 1;
    }
    LookupElements { z: QM31Trait::from_fixed_array([M31Trait::reduce_u32(1), M31Trait::reduce_u32(2), M31Trait::reduce_u32(3), M31Trait::reduce_u32(4)]), alpha: One::one(), alpha_powers }
}

pub fn dummy_circle_point() -> CirclePoint<QM31> {
    CirclePoint { x: One::one(), y: Zero::zero() }
}

pub fn build_dummy_preprocessed_mask_values(
    ref preprocessed_column_set: PreprocessedColumnSet,
) -> PreprocessedMaskValues {
    let mut values_storage = array![];
    for _ in preprocessed_column_set.values.span() {
        let mut values = array![];
        values.append(One::one());
        values_storage.append(values);
    }
    let mut spans_storage = array![];
    let mut values_iter = values_storage.span();
    loop {
        if let Some(values) = values_iter.pop_front() {
            spans_storage.append(values.span());
        } else {
            break;
        }
    }
    PreprocessedMaskValuesImpl::new(
        spans_storage.span(),
        preprocessed_column_set.values.span(),
    )
}

pub fn build_dummy_mask_spans(
    mask_points: @Array<Array<CirclePoint<QM31>>>,
) -> (Array<Array<QM31>>, Array<Span<QM31>>) {
    let mut values_storage = array![];
    let mut mask_iter = mask_points.span();
    loop {
        let len = if let Some(mask) = mask_iter.pop_front() {
            mask.len()
        } else {
            break;
        };
        let mut values = array![];
        let mut index = 0_usize;
        while index < len {
            values.append(One::one());
            index += 1;
        }
        values_storage.append(values);
    }
    let mut spans_storage = array![];
    let mut values_iter = values_storage.span();
    loop {
        if let Some(values) = values_iter.pop_front() {
            spans_storage.append(values.span());
        } else {
            break;
        }
    }
    (values_storage, spans_storage)
}

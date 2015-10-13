#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import numpy
from theanolm.trainers.basictrainer import BasicTrainer

class MeanValidationTrainer(BasicTrainer):
    """A trainer that computes perplexity at several points after the actual
    validation point and computes the mean.

    Validating at a single training point is sensitive to noise in the computed
    perplexity values. Mean validation allows faster reaction to increasing
    validation set perplexity.
    """

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.local_perplexities = None

    def _validate(self, perplexity):
        if not perplexity is None:
            self.local_perplexities = [perplexity]
        else:
            if not self.local_perplexities is None:
                perplexity = self.scorer.compute_perplexity(self.validation_iter)
                self.local_perplexities.append(perplexity)
                if len(self.local_perplexities) >= 10:
                    mean = numpy.mean(numpy.asarray(self.local_perplexities))
                    super()._validate(mean)
                    self.local_perplexities = None
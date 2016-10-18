#!/bin/bash -e
#
# Examples for training TheanoLM models on Penn Treebank corpus. The results (in
# comments) have been obtained using the processed data that is distributed with
# RNNLM basic examples. The vocabulary is 10002 words including the <s> and </s>
# symbols. With such a small vocabulary, noise-contrastive estimation does not
# improve training speed. Hierarchical softmax improves training speed with only
# a small degradation in model performance.

script_dir=$(dirname "${0}")
script_dir=$(readlink -e "${script_dir}")
arch_dir="${script_dir}/../architectures"

# Load paths to the corpus files. You need to download the Penn Treebank corpus
# e.g. from http://www.fit.vutbr.cz/~imikolov/rnnlm/simple-examples.tgz and
# create paths.sh with:
#
# TRAIN_FILES=(/path/to/penn-treebank-project/ptb.train.txt)
# DEVEL_FILE=/path/to/penn-treebank-project/ptb.valid.txt
# EVAL_FILE=/path/to/penn-treebank-project/ptb.test.txt
# OUTPUT_DIR=/path/to/output/directory
#
source "${script_dir}/paths.sh"

# Load common functions.
source "${script_dir}/../common/functions.sh"

# Set common training parameters.
OPTIMIZATION_METHOD=sgd
MAX_GRADIENT_NORM=5
STOPPING_CRITERION=no-improvement
VALIDATION_FREQ=1
PATIENCE=0

### softmax ####################################################################

ARCHITECTURE_FILE="${arch_dir}/word-lstm256.arch"
COST=cross-entropy
LEARNING_RATE=10
rm -f "${OUTPUT_DIR}/nnlm.h5"
train
compute_perplexity

# Model performance stopped improving. Decreasing learning rate from 1.25 to 0.625 and resetting state to 100 % of epoch 7.
# Finished training epoch 7. Best validation perplexity 119.39.
# Training finished.
# Best validation set perplexity: 119.111157578
# Number of sentences: 3761
# Number of words: 86191
# Number of predicted probabilities: 82430
# Cross entropy (base e): 4.745124991316969
# Perplexity: 115.02218137859198
# ./01-models.sh  3348.84s user 1693.31s system 99% cpu 1:24:10.01 total

### hierarchical softmax #######################################################

#ARCHITECTURE_FILE="${arch_dir}/word-lstm256-hsoftmax.arch"
#COST=cross-entropy
#LEARNING_RATE=10
#rm -f "${OUTPUT_DIR}/nnlm.h5"
#train
#compute_perplexity

# Model performance stopped improving. Decreasing learning rate from 1.25 to 0.625 and resetting state to 100 % of epoch 8.
# Finished training epoch 8. Best validation perplexity 128.52.
# Training finished.
# Best validation set perplexity: 128.350350939
# Number of sentences: 3761
# Number of words: 86191
# Number of predicted probabilities: 82430
# Cross entropy (base e): 4.8130102843700175
# Perplexity: 123.1016312310178
# ./01-models.sh  2116.11s user 863.28s system 99% cpu 49:53.37 total

## noise-contrastive estimation ################################################

#ARCHITECTURE_FILE="${arch_dir}/word-lstm256.arch"
#COST=nce
#NUM_NOISE_SAMPLES=3
#LEARNING_RATE=100
#rm -f "${OUTPUT_DIR}/nnlm.h5"
#train
#compute_perplexity

# Model performance stopped improving. Decreasing learning rate from 0.78125 to 0.390625 and resetting state to 100 % of epoch 19.
# Finished training epoch 19. Best validation perplexity 214.17.
# Training finished.
# Best validation set perplexity: 214.095839821
# Number of sentences: 3761
# Number of words: 86191
# Number of predicted probabilities: 82430
# Cross entropy (base e): 5.3010221007632845
# Perplexity: 200.5416790617706
# ./01-models.sh  5647.11s user 2248.88s system 99% cpu 2:11:39.85 total

## noise-contrastive estimation with shared noise samples ######################

#ARCHITECTURE_FILE="${arch_dir}/word-lstm256.arch"
#COST=nce-shared
#NUM_NOISE_SAMPLES=100
#LEARNING_RATE=500
#rm -f "${OUTPUT_DIR}/nnlm.h5"
#train
#compute_perplexity

# Model performance stopped improving. Decreasing learning rate from 0.9765625 to 0.48828125 and resetting state to 100 % of epoch 16.
# Finished training epoch 16. Best validation perplexity 189.13.
# Training finished.
# Best validation set perplexity: 189.122505233
# train finished.
# Number of sentences: 3761
# Number of words: 86191
# Number of predicted probabilities: 82430
# Cross entropy (base e): 5.198794576222683
# Perplexity: 181.05386365022255
# ./01-models.sh  5243.30s user 2135.05s system 99% cpu 2:03:02.97 total

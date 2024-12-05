#!/bin/bash

# TODO: Replace <your_checkpoint_name> to your own checkpoint name. 
YOUR_CHECKPOINT_DIR=""
YOUR_PROJECT_PATH=""


# Check if MODEL_NAME is provided as a command line argument
if [ -z "$1" ]; then
  echo "Usage: $0 <MODEL_NAME> <DATASET1> <DATASET2> ..."
  exit 1
fi

# Set the model name and checkpoint
MODEL_NAME="$1"
CKPT="$MODEL_NAME"

# Shift the arguments so that $@ only contains datasets
shift

# Iterate through and print each parameter
for param in "$@"; do
  echo "Ready to eval datasets: $param"
done

for param in "$@"; do
  echo "Now we are evaluating: $param"
  if [ "$param" = "textvqa" ]; then
    echo "The parameter is textvqa."

    ######################## 1 text vqa ###############################
    python -m llava.eval.model_vqa_loader \
        --model-path ${YOUR_CHECKPOINT_DIR}/${MODEL_NAME} \
        --question-file ${YOUR_PROJECT_PATH}/eval_results/textvqa/llava_textvqa_val_v051_ocr.jsonl \
        --image-folder /data/JoeyLin/llava/llava1-5/data/eval/textvqa/train_images \
        --answers-file ${YOUR_PROJECT_PATH}/eval_results/textvqa/answers/${MODEL_NAME}.jsonl \
        --temperature 0 \
        --conv-mode v1 &&
    sleep 5;

    python -m llava.eval.eval_textvqa \
        --annotation-file ${YOUR_PROJECT_PATH}/eval_results/textvqa/TextVQA_0.5.1_val.json \
        --result-file ${YOUR_PROJECT_PATH}/eval_results/textvqa/answers/${MODEL_NAME}.jsonl
    #################################################################
  fi


  if [ "$param" = "vqav2" ]; then
    gpu_list="${CUDA_VISIBLE_DEVICES:-0}"
    IFS=',' read -ra GPULIST <<< "$gpu_list"

    CHUNKS=1
    SPLIT="llava_vqav2_mscoco_test-dev2015"
    ########################## 2 vqav2 ###############################
    for IDX in $(seq 0 $((CHUNKS-1))); do
        CUDA_VISIBLE_DEVICES=${GPULIST[$IDX]} python -m llava.eval.model_vqa_loader \
            --model-path ${YOUR_CHECKPOINT_DIR}/${MODEL_NAME} \
            --question-file <your_data_path>/eval/vqav2/$SPLIT.jsonl \
            --image-folder <your_data_path>/test2015 \
            --answers-file  ${YOUR_PROJECT_PATH}/eval_results/vqav2/answers/$SPLIT/$CKPT/${CHUNKS}_${IDX}.jsonl \
            --num-chunks $CHUNKS \
            --chunk-idx $IDX \
            --temperature 0 \
            --conv-mode v1 &
    done

    wait

    output_file=${YOUR_PROJECT_PATH}/eval_results/vqav2/answers/$SPLIT/$CKPT/merge.jsonl

    # Clear out the output file if it exists.
    > "$output_file"

    # Loop through the indices and concatenate each file.
    for IDX in $(seq 0 $((CHUNKS-1))); do
        cat ${YOUR_PROJECT_PATH}/eval_results/vqav2/answers/$SPLIT/$CKPT/${CHUNKS}_${IDX}.jsonl >> "$output_file"
    done
    
    python ${YOUR_PROJECT_PATH}/llava/scripts/convert_vqav2_for_submission.py --split $SPLIT --ckpt $CKPT
    #################################################################
  fi



  if [ "$param" = "mme" ]; then
    ######################## 3 mme ###############################
    python -m llava.eval.model_vqa_loader \
       --model-path ${YOUR_CHECKPOINT_DIR}/${MODEL_NAME} \
       --question-file  /code/chr/EVAL/eval_results/MME/llava_mme.jsonl \
       --image-folder  /code/chr/EVAL/eval_results/MME/MME_Benchmark_release_version \
       --answers-file  ${YOUR_PROJECT_PATH}/eval_results/MME/answers/${MODEL_NAME}.jsonl \
       --temperature 0 \
       --conv-mode v1 &&

    cd  ${YOUR_PROJECT_PATH}/eval_results/MME
    python ${YOUR_PROJECT_PATH}/eval_results/MME/convert_answer_to_mme.py --experiment ${MODEL_NAME};

    cd eval_tool
    # get the subtasks results of mme
    python  ${YOUR_PROJECT_PATH}/eval_results/MME/eval_tool/calculation.py --results_dir  ${YOUR_PROJECT_PATH}/eval_results/MME/eval_tool/answers/${MODEL_NAME}

 
    #################################################################
  fi

  if [ "$param" = "mmbench" ]; then
    ########################## 4 mmbench ###############################
    SPLIT="mmbench_dev_20230712"

    python -m llava.eval.model_vqa_mmbench \
        --model-path ${YOUR_CHECKPOINT_DIR}/${MODEL_NAME} \
        --question-file ${YOUR_PROJECT_PATH}/eval_results/mmbench/mmbench/$SPLIT.tsv \
        --answers-file ${YOUR_PROJECT_PATH}/eval_results/mmbench/answers/$SPLIT/${MODEL_NAME}.jsonl \
        --single-pred-prompt \
        --temperature 0 \
        --conv-mode v1 &&
  
    mkdir -p ${YOUR_PROJECT_PATH}/eval_results/mmbench/answers_upload/${MODEL_NAME};

    python ${YOUR_PROJECT_PATH}/llava/scripts/convert_mmbench_for_submission.py \
        --annotation-file ${YOUR_PROJECT_PATH}/eval_results/mmbench/eval/mmbench/$SPLIT.tsv \
        --result-dir ${YOUR_PROJECT_PATH}/eval_results/mmbench/answers/$SPLIT/${MODEL_NAME} \
        --upload-dir </code/chr/llava>/llava/eval_results/mmbench/answers_upload/${MODEL_NAME} \
        --experiment ${MODEL_NAME}
    #################################################################
  fi  
done
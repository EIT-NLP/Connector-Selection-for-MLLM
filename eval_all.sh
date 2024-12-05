# evaluate mme and mmbench
# TODO: Replace <your_checkpoint_name> to your own checkpoint name. 
# bash eval_pipeline.sh /home/LLaVA/checkpoint/llava-mlp2-336-merge mme;
bash eval_pipeline_test.sh llava-mlp2-448-merge mme;
bash eval_pipeline_test.sh llava-mlp2-448-merge mmbench;
bash eval_pipeline_test.sh llava-mlp2-448-merge textvqa;
bash eval_pipeline_test.sh llava-mlp2-448-merge vqav2;



# evaluate seedbench,gqa,vizwiz_vqa,pope,refcoco,refcoco+,refcocog,scienceqa
# TODO: Replace <your_checkpoint_path> to your own checkpoint path.
python3 -m accelerate.commands.launch \
    --num_processes=8 \
    -m lmms_eval \
    --model llava \
    --model_args pretrained="<your_checkpoint_path>" \
    --tasks seedbench,gqa,vizwiz_vqa,pope,refcoco,refcoco+,refcocog,scienceqa \
    --batch_size 1 \
    --log_samples \
    --log_samples_suffix seedbench_gqa_vizwiz_vqa_pope_refcoco_refcoco+_refcocog_scienceqa \
    --output_path ./eval_results/seedbench_gqa_vizwiz_vqa_pope_refcoco_refcoco+_refcocog_scienceqa/;
    
# combine three results and get corase perception, fine-grained perception and reasoning reuslts specifically

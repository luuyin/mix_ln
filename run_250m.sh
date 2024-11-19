norm_type=$1
learning_rates=$2
export NORM_TYPE=$norm_type
export POST_NUM=$3
master_port=$4

# Function to run a single training task

echo "Training with learning rate: $learning_rates, norm type: $norm_type on GPU $gpu"

CUDA_VISIBLE_DEVICES=0 torchrun --nproc_per_node 1 --master_port=$master_port torchrun_main.py \
    --model_config configs/llama_250m.json \
    --lr $learning_rates \
    --batch_size 128 \
    --total_batch_size 512 \
    --num_training_steps 60000 \
    --warmup_steps 6000 \
    --weight_decay 0 \
    --dtype bfloat16 \
    --eval_every 1000 \
    --optimizer adam \
    --grad_clipping 0.0 \
    --run_name "250m_${norm_type}_${POST_NUM}_lr${learning_rates}" \
    --save_dir "models/250m_${norm_type}_${POST_NUM}_lr${learning_rates}"



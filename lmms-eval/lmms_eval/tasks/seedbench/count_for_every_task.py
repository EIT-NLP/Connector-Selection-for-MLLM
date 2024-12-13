import json

tasks_name = [
"Scene Understanding",
"Instance Identity",
"Instance Attribute",
"Instance Location",
"Instance Counting",
"Spatial Relation",
"Instance Interaction",
"Visual Reasoning",
"Text Recognition",
"Action Recognition",
"Action Prediction",
"Procedure Understanding"
]

cate = []
def seed_aggregation_result(results):
    total_count = 0
    total_correct = 0
    cat = {}
    count = 0
    for result in results:
        count+=1
        if result['gpt_eval_score']['category'] in cat:
            cat[result['gpt_eval_score']['category']]+=1
        else:
            cat[result['gpt_eval_score']['category']]=1
    return cat


import pandas as pd
path = "/code/lmms-eval/logs/0614_1425_llava-c-abstractor-64-224-merge_seedbench_llava_model_args_ab7596/seedbench.json"
with open(path) as file:
    data = json.load(file)
result = data['logs']
output = seed_aggregation_result(result)
print(output)


# Method name extracted from the path
method_name = 'c-abstractor-64-224'
# method_name = 'c-abstracor-64-448'
# method_name = 'c-abstracor-64-448'
# Create a DataFrame from the output dictionary
df = pd.DataFrame([output], index=[method_name])

# Save the DataFrame to an Excel file
df.to_excel('/code/lmms-eval/lmms_eval/tasks/seedbench/c-abstractor-64-224-evaluation_results.xlsx')

print("Data saved to 'evaluation_results.xlsx'.")




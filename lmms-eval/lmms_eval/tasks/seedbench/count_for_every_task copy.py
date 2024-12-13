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

def seed_aggregation_result(results):
    total_count = 0
    total_correct = 0
    correct_list = [0 for _ in range(12)]
    count_list = [0 for _ in range(12)]
    for result in results:
        try:
            if result['seed_image']['pred'] == result['seed_image']['answer']:
                total_correct += 1
                correct_list[result['doc']['question_type_id']-1] += 1
            total_count += 1
            count_list[result['doc']['question_type_id']-1] += 1
        except:
            continue

        # Calculate total and individual task accuracies
    total_accuracy = total_correct / total_count if total_count > 0 else 0
    task_accuracies = {}
    for i, task in enumerate(tasks_name):
        if count_list[i] > 0:
            task_accuracy = correct_list[i] / count_list[i]
        else:
            task_accuracy = 0  # No data for this task
        task_accuracies[task] = task_accuracy
    
    # Combine total accuracy and task accuracies into one dictionary
    result_dict = {"total": total_accuracy}
    result_dict.update(task_accuracies)
    return result_dict


import pandas as pd
path = "/code/lmms-eval/logs/0614_1455_llava-linear-224-merge_seedbench_llava_model_args_7e772e/seedbench.json"
with open(path) as file:
    data = json.load(file)
result = data['logs']
output = seed_aggregation_result(result)
print(output)


# Method name extracted from the path
method_name = 'linear-224-merge'
# method_name = 'c-abstracor-64-448'
# method_name = 'c-abstracor-64-448'
# Create a DataFrame from the output dictionary
df = pd.DataFrame([output], index=[method_name])

# Save the DataFrame to an Excel file
df.to_excel('/code/lmms-eval/lmms_eval/tasks/seedbench/linear-224-merge-336-evaluation_results----.xlsx')

print("Data saved to 'evaluation_results.xlsx'.")




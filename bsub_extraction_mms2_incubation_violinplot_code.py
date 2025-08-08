import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
import numpy as np

# Your data
mms2_inc_v_5sec = [104.12, 12468.96]
print(np.mean(mms2_inc_v_5sec))

mms2_inc_v_15sec = [2277.68, 1825.30, 4121.88]
print(np.mean(mms2_inc_v_15sec))

mms2_inc_v_30sec = [545.36, 356.53, 23224.55]
print(np.mean(mms2_inc_v_30sec))

mms2_inc_v_60sec = [1138.87, 18101.11, 1091.28]
print(np.mean(mms2_inc_v_60sec))

mms2_inc_v_120sec =[230.95, 91.50, 173.21]
print(np.mean(mms2_inc_v_120sec))

mms2_inc_v_300sec = [76.01, 107.14, 80.01]
print(np.mean(mms2_inc_v_300sec))

mms2_inc_hs = [197.76, 48.63, 27.79]
print(np.mean(mms2_inc_hs))

# Prepare the data in a tidy format
df = pd.DataFrame({
    'Percentage of Extracted Cells Relative to Control (%)': mms2_inc_v_5sec + mms2_inc_v_15sec + mms2_inc_v_30sec + mms2_inc_v_60sec + mms2_inc_v_120sec + mms2_inc_v_300sec 
    + mms2_inc_hs,
    'Separation Technique': ['V-5sec'] * len(mms2_inc_v_5sec) + ['V-15sec'] * len(mms2_inc_v_15sec) + ['V-30sec'] * len(mms2_inc_v_30sec) + ['V-60sec'] * len(mms2_inc_v_60sec)
    + ['V-120sec'] * len(mms2_inc_v_120sec) + ['V-300sec'] * len(mms2_inc_v_300sec) + ['HS'] *len(mms2_inc_hs)
})

print(df)

# Define custom colors for each group
colors_15 = [
    "#1f77b4",  # muted blue
    "#ff7f0e",  # safety orange
    "#2ca02c",  # cooked asparagus green
    "#d62728",  # brick red
    "#9467bd",  # muted purple
    "#8c564b",  # chestnut brown
    "#e377c2",  # raspberry yogurt pink
    "#7f7f7f",  # middle gray
    "#bcbd22",  # curry yellow-green
    "#17becf",  # blue-teal
    "#393b79",  # dark slate blue
    "#637939",  # olive green
    "#8c6d31",  # dark goldenrod
    "#843c39",  # dark red
    "#7b4173"   # dark orchid
]

my_colors = {'V-5sec': colors_15[0], 'V-15sec': colors_15[14], 'V-30sec': colors_15[1], 'V-60sec': colors_15[13], 'V-120sec': colors_15[2], 'V-300sec': colors_15[12], 
             'HS': colors_15[3]}

plt.figure(figsize=(15, 10))
#sns.violinplot(x='Group', y='Value', data=df, inner='box', linewidth=1.2)
sns.violinplot(
    x='Separation Technique',
    y='Percentage of Extracted Cells Relative to Control (%)',
    data=df,
    palette=my_colors,
    width=0.5,
    saturation=0.6,  # Adjust this value (0 to 1) for desired color intensity
    #inner='box',
    #inner='quart',
    inner='point', 
    linewidth=3
)
#sns.stripplot(
#    x='Group',
#    y='Value',
#    data=df,
#    color='black',
#    size=8,
#    jitter=True,
#    alpha=0.7
#)

plt.xlabel('Separation Technique', fontsize=18)  # x-axis label size
plt.ylabel('Percentage of Extracted Cells Relative to Control (%)', fontsize=18)  # y-axis label size
plt.xticks(fontsize=14)  # x-tick label size
plt.yticks(fontsize=14)  # y-tick label size

plt.title('Main experiments - MMS-2 + Incubation', fontsize=20)
plt.show()

print(f"MMS-2 + Inc + V5 = {np.median(mms2_inc_v_5sec)}")
print(f"MMS-2 + Inc + V15 = {np.median(mms2_inc_v_15sec)}")
print(f"MMS-2 + Inc + V30 = {np.median(mms2_inc_v_30sec)}")
print(f"MMS-2 + Inc + V60 = {np.median(mms2_inc_v_60sec)}")
print(f"MMS-2 + Inc + V120 = {np.median(mms2_inc_v_120sec)}")
print(f"MMS-2 + Inc + V300 = {np.median(mms2_inc_v_300sec)}")
print(f"MMS-2 + Inc + HS = {np.median(mms2_inc_hs)}")

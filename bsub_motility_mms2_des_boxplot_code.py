import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
import numpy as np

# Your data
mms2_des_v_5sec = [0.00, 0.00, 0.00, 0.00, 789.26, 393.59, 0.00, 0.00, 0.00, 288.94, 113.09, 0.00, 0.00]
print(np.mean(mms2_des_v_5sec))

mms2_des_v_15sec = [0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 1180.09, 0.00, 824.45]
print(np.mean(mms2_des_v_15sec))

mms2_des_v_30sec = [2432.45, 1912.08, 2589.81, 3388.28, 0.00, 0.00, 1260.09, 0.00, 0.00, 0.00, 0.00, 1771.09, 0.00, 0.00]
print(np.mean(mms2_des_v_30sec))

mms2_des_v_60sec = [0.00, 0.00, 0.00, 0.00, 0.00, 729.34, 832.48, 1084.42, 0.00, 0.00, 743.82, 457.02, 369.58, 783.05]
print(np.mean(mms2_des_v_60sec))

mms2_des_v_120sec = [0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00]
print(np.mean(mms2_des_v_120sec))

mms2_des_v_300sec = [
    9464.06, 4301.85, 11356.87, 10816.07, 0.00, 0.00, 4673.61, 0.00, 0.00,
    3819.04, 0.00, 6429.94, 1585.60, 6692.82, 2021.70
]
print(np.mean(mms2_des_v_300sec))

mms2_des_hs = [1210.48, 1928.08, 2058.36, 1206.48, 648.16, 0.00, 870.39, 923.14, 1582.53, 743.02, 0.00, 297.21, 591.53, 564.14]
print(np.mean(mms2_des_hs))

# Prepare the data in a tidy format
df = pd.DataFrame({
    'Percentage of Motile Extracted Cells Relative to Control (%)': mms2_des_v_5sec + mms2_des_v_15sec + mms2_des_v_30sec + mms2_des_v_60sec + mms2_des_v_120sec 
    + mms2_des_v_300sec + mms2_des_hs,
    'Separation Technique': ['V-5sec'] * len(mms2_des_v_5sec) + ['V-15sec'] * len(mms2_des_v_15sec) + ['V-30sec'] * len(mms2_des_v_30sec) + ['V-60sec'] * len(mms2_des_v_60sec)
    + ['V-120sec'] * len(mms2_des_v_120sec) + ['V-300sec'] * len(mms2_des_v_300sec) + ['HS'] *len(mms2_des_hs)
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

my_colors = {'V-5sec': colors_15[0], 'V-15sec': colors_15[14], 'V-30sec': colors_15[1], 'V-60sec': colors_15[13], 'V-120sec':colors_15[2], 'V-300sec': colors_15[12], 
             'HS': colors_15[3]}


plt.figure(figsize=(15, 10))
sns.boxplot(
    x='Separation Technique',
    y='Percentage of Motile Extracted Cells Relative to Control (%)',
    data=df,
    palette=my_colors,
    width=0.5,
    saturation=0.6  # Adjust this value (0 to 1) for desired color intensity
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

# Limit the y-axis range to, for example, 0 to 1000
#ax.set_ylim(90, 500)

plt.xlabel('Separation Technique', fontsize=18)  # x-axis label size
plt.ylabel('Percentage of Motile Extracted Cells Relative to Control (%)', fontsize=18)  # y-axis label size
plt.xticks(fontsize=14)  # x-tick label size
plt.yticks(fontsize=14)  # y-tick label size

plt.title('Main experiments - MMS-2 + Desiccation - Motility Plot', fontsize=20)
plt.show()

print(f"MMS-2 + Desiccation + V5 = {np.median(mms2_des_v_5sec)}")
print(f"MMS-2 + Desiccation + V15 = {np.median(mms2_des_v_15sec)}")
print(f"MMS-2 + Desiccation + V30 = {np.median(mms2_des_v_30sec)}")
print(f"MMS-2 + Desiccation + V60 = {np.median(mms2_des_v_60sec)}")
print(f"MMS-2 + Desiccation + V120 = {np.median(mms2_des_v_120sec)}")
print(f"MMS-2 + Desiccation + V300 = {np.median(mms2_des_v_300sec)}")
print(f"MMS-2 + Desiccation + HS = {np.median(mms2_des_hs)}")

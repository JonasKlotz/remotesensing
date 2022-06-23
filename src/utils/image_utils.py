import torch
import torchvision.transforms.functional as F
import matplotlib.pyplot as plt
import numpy as np




def show(imgs, index=0):
    """
    Plots images from Pytorch Tensor format to matplotlib
    :param imgs:
    :return:
    """
    n_img = imgs.shape[0]
    fig, axs = plt.subplots(ncols=len(imgs), squeeze=False)

    for i in range (n_img):
        img= imgs[i,...]
        if isinstance(img, torch.Tensor):
            img = img.permute(1, 2, 0)
        if torch.min(img) < 0:
            img = ((img+1)*128).to(torch.int)

        axs[0, i].imshow(np.asarray(img), vmin=0, vmax=255)
        axs[0, i].set(xticklabels=[], yticklabels=[], xticks=[], yticks=[])
    plt.savefig(f"results/img_{index}.png")
    plt.show()



def barplot_results(prediction, results, labels, loss, index=0):
    # Declaring the figure or the plot (y, x) or (width, height)
    fig = plt.figure(figsize=[15, 10])

    # Data to be plotted
    prediction = (prediction.flatten().numpy()).copy()
    results = (results.flatten().numpy()).copy()
    # Using numpy to group 3 different data with bars
    X = np.arange(len(labels))+1
    # Passing the parameters to the bar function, this is the main function which creates the bar plot

    # Using X now to align the bars side by side
    plt.bar(X, prediction, color='lightblue', width=0.3)
    plt.bar(X + 0.3, results, color='grey', width=0.3)

    # Creating the legend of the bars in the plot
    plt.legend(['Prediction', 'True Label'])

    # Overiding the x axis with the country names
    plt.xticks(ticks=X, labels=labels)
    # Giving the tilte for the plot
    plt.title(f"Barplot with total BCE Loss of {loss}")
    # Namimg the x and y axis
    plt.xlabel('Labels')
    plt.ylabel('Predicted Accuracy')
    # Saving the plot as a 'png'
    fig.savefig(f'results/boxplot_{index}.png')
    # Displaying the bar plot
    plt.show()
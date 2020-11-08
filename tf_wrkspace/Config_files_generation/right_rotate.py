#Initialize array
arr = [1,2,3,4,5,6,7,8,9,10];
test_list = [1,2,3,4,5,6,7,8,9,10];
#n determine the number of times an array should be rotated
n = 5;

#Displays original array
# print("Original array: ");
# for i in range(0, len(arr)):
#     print(arr[i]),

#Rotate the given array by n times toward right
# for i in range(0, n):
#     #Stores the last element of array
#     last = arr[len(arr)-1];

#     for j in range(len(arr)-1, -1, -1):
#         #Shift element of array by one
#         arr[j] = arr[j-1];

#     #Last element of the array will be added to the start of the array.

#     arr[0] = last;

# print();

#Displays resulting array after rotation


# print("Array after right rotation:");
# for i in range(0, len(arr)):
#     print(arr[i])



print ("Original list : " + str(test_list))

# using slicing to left rotate by 3
test_list = test_list[n:] + test_list[:n]

# Printing list after left rotate
print ("List after left rotate by 3 : " + str(test_list))

# using slicing to right rotate by 3
# back to Original
test_list = [1,2,3,4,5,6,7,8,9,10];
print(test_list[-3:])
print(test_list[:-3])
test_list = test_list[-3:] + test_list[:-3]
# Printing after right rotate
print ("List after right rotate by 3(back to original) : "+ str(test_list))
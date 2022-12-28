def recursive_items(dictionary,key_str):
    key_lst = key_str.split('/')
       temp_dict = dictionary
    for i in key_lst:
        if type(temp_dict[i]) is dict:
            temp_dict = temp_dict.get(i)
        else:
           return temp_dict[i]
object1 = {"a":{"b":{"c":"d"}}}
object2 = {"x":{"y":{"z":"a"}}}
print(recursive_items(object2,"x/y/z"))



########Test case#############

# Output - 

# satya@linux:~$ python3 nestedobject.py
# a

###############################################

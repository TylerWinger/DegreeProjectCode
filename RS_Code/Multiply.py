a = [0,1,1,0]   #enter golois vectors
b = [1,1,0,1]   
multiply = [0,0,0,0]
multiply[0] = (a[3]&b[0]) ^ (a[2]&b[1]) ^ (a[1]&b[2]) ^ (a[0]&b[3]) ^ (a[0]&b[0])
multiply[1] = (a[3]&b[1]) ^ (a[2]&b[2]) ^ (a[1]&b[3]) ^ (a[0]&b[0]) ^ (a[0]&b[1]) ^ (a[1]&b[0])
multiply[2] = (a[3]&b[2]) ^ (a[2]&b[3]) ^ (a[0]&b[1]) ^ (a[1]&b[0]) ^ (a[2]&b[0]) ^ (a[1]&b[1]) ^ (a[0]&b[2])
multiply[3] = (a[3]&b[3]) ^ (a[2]&b[0]) ^ (a[1]&b[1]) ^ (a[0]&b[2])

print(multiply) #answer in a galois vector

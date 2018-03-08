function new_obj = full_copy(obj)
   
    objByteArray = getByteStreamFromArray(obj);
    new_obj = getArrayFromByteStream(objByteArray);
    
end
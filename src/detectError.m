function DD=detectError(A,B)

DD=A-B;
DD=DD.^2;
DD=sum(DD,2);
DD=sqrt(DD);

end
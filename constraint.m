function xx = constraint(x)

%cons1
x1=x(:,1)
x2=x(:,2)
cons1=x1+2.*x2-2000;
h1=find(cons1>0); 
x(h1,:)=[]; 

%cons2
x1=x(:,1)
x2=x(:,2)
cons2=x1+x2-1500;
h2=find(cons2>0); 
x(h2,:)=[]; 

%cons3
x1=x(:,1)
x2=x(:,2)
cons3=x2-600;
h3=find(cons3>0); 
x(h3,:)=[]; 

xx = x; 
end
function TSE3invers = TSE3invers(h)
homega=h(1:3);
hU=h(4:6);
TSE3invers = [TSO3invers(homega) TUomegaminus(hU,homega); zeros(3) TSO3invers(homega)];
end
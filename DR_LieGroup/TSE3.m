function TSE3 = TSE3(h)
homega=h(1:3);
hU=h(4:6);
TSE3 = [TSO3(homega) TUomegaplus(hU,homega); zeros(3) TSO3(homega)];
end
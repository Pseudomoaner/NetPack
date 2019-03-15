function [A, R] = im_hessangle2(im, scale)

g2 = im_hessstrflt2(im, scale);

tmp = sqrt((g2(:,:,1)- g2(:,:,3)).*(g2(:,:,1)- g2(:,:,3)) + 4 * g2(:,:,2).*g2(:,:,2));
eigvalue1 = (g2(:,:,1) + g2(:,:,3) + tmp)/2;
eigvalue2 = (g2(:,:,1) + g2(:,:,3) - tmp)/2;
eigangle1 = atan(g2(:,:,2)./(eigvalue1 - g2(:,:,3)+realmin));
eigangle2 = atan(g2(:,:,2)./(eigvalue2 - g2(:,:,3)+realmin));

A = eigvalue1.*(abs(eigvalue1)>=abs(eigvalue2)) + eigvalue2.*(abs(eigvalue1)<abs(eigvalue2));
R = eigangle2.*(abs(eigvalue1)>=abs(eigvalue2)) + eigangle1.*(abs(eigvalue1)<abs(eigvalue2));

R(R < 0) = R(R < 0) + pi;
R = R*180/ pi;

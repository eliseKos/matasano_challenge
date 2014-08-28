#!/usr/bin/env ruby
#technion@lolware.net
#
#ported from the python at http://algorithmist.com/index.php/Modular_inverse
require 'openssl'

class RSA
    Bits = 256
    def initialize
        #Public key is @e, @n
        #Private key is @d, @n
        p = OpenSSL::BN::generate_prime(Bits)
        p = p.to_i
        q = OpenSSL::BN::generate_prime(Bits)
        q = q.to_i
        @n = p * q
        et = (p-1) * (q-1)
        @e = 3
        @d = modinv(@e, et)
    end

    def encrypt(m)
        return m.to_bn.mod_exp(@e, @n)
    end
    
    def decrypt(c)
        return c.to_bn.mod_exp(@d, @n)
    end

    private
    def recursive_egcd(a, b)
        #Returns a triple (g, x, y), such that ax + by = g = gcd(a,b).
        #Assumes a, b >= 0, and that at least one of them is > 0.
        #Bounds on output values: |x|, |y| <= max(a, b).
        #g removed because we don't want it
        return [0, 1] if a == 0
        y, x = recursive_egcd(b % a, a)
        return [x - (b / a)*y, y]
    end

    def modinv(e, et)
        x, y = recursive_egcd(e, et) 
        #raise "Math failure on modinv" if g != 1
        return x % et
    end
end

r = RSA.new

c = r.encrypt(42)
m = r.decrypt(c)
puts "The m was #{m} and c was #{c}"


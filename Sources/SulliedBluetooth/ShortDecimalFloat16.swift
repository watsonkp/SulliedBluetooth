import Foundation

// IEEE 11073-20601 16-bit SFLOAT
enum ShortDecimalFloat16 {
    case NaN
    case Nres
    case infinity
    case negativeInfinity
    case reservedForFutureUse
    case finite(Decimal)
}

extension ShortDecimalFloat16 : Equatable { }

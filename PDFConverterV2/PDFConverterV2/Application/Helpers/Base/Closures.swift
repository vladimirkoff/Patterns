
import Foundation

typealias VoidClosure = () -> Void
typealias BoolClosure = (Bool) -> Void
typealias StringClosure = (String) -> Void
typealias IntClosure = (Int) -> Void
typealias ErrorClosure = (Error) -> Void
typealias ResultClosure<T,E: Error> = (Result<T, E>) -> Void

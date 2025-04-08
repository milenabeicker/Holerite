//
//  ContentView.swift
//  Holerite
//
//  Created by Milena Beicker on 18/03/25.
//

import SwiftUI

struct ContentView: View {
    @State private var salarioBruto: String = ""
    @State private var descontoAdicional: String = ""
    
    @State private var descontos: Double = 0.0
    @State private var salarioLiquido: Double = 0.0
    @State private var descontoINSS: Double = 0.0
    @State private var descontoIRPF: Double = 0.0
    @State private var efetivoINSS: Double = 0.0
    @State private var efetivoIRPF: Double = 0.0
    
    var body: some View {
        NavigationStack {
            //  VStack{
            Form {
                // Campo para Salário Bruto
                Section(header: Text("Dados de Entrada")) {
                    TextField("Digite o Salário Bruto", text: $salarioBruto)
                        .keyboardType(.decimalPad)
                    
                    // Campo para Descontos
                    TextField("Descontos Adicionais", text: $descontoAdicional)
                        .keyboardType(.decimalPad)
                }
                
                Button("Cálcular Salário Líquido"){
                    calcularSalarioLiquido()
                }
                .font(.title2.bold())
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(8)
                
                Section(header: Text("")) {
                    if let salary = Double(salarioBruto), salary > 0 {
                        Text("Salário Bruto: R$ \(String(format: "%.2f", salary))")
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                    
                    if descontoINSS > 0 {
                        Text("INSS: R$ \(String(format: "%.2f", descontoINSS))   (\(String(format: "%.2f", efetivoINSS))%)")
                            .foregroundColor(.red)
                    }
                    
                    if descontoIRPF > 0 {
                        Text("IRPF: R$ \(String(format: "%.2f", descontoIRPF))   (\(String(format: "%.2f", efetivoIRPF))%)")
                            .foregroundColor(.red)
                    }
                    
                    if let extra = Double(descontoAdicional), extra > 0 {
                        Text("Desconto Adicional: R$ \(String(format: "%.2f", extra))")
                            .foregroundColor(.red)
                    }
                    
                    if descontos > 0 {
                        Text("Total de descontos: R$ \(String(format: "%.2f", descontos))")
                            .foregroundColor(.red)
                    }
                    
                    // Exemplo de uso direto de salarioLiquido (já que não é opcional)
                    if salarioLiquido > 0 {
                        Text("Salário Líquido: R$ \(String(format: "%.2f", salarioLiquido))")
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                }
                
                
            } //Form:
            .navigationTitle("Holerite")
            
            //   }//VStack:
            
        }//NavigationStack:
    }//body:
    
    func calcularSalarioLiquido() {
        let salarioB = Double(salarioBruto) ?? 0.0
        
        // Cálculo do desconto de INSS
        let resultInss = calculoINSS(salary: salarioB)
        descontoINSS = resultInss
        efetivoINSS = salarioB > 0 ? (resultInss / salarioB) * 100 : 0
        
        // Base para cálculo do IRRF
        let baseParaIRPF = salarioB - resultInss
        
        // Cálculo do desconto de IRRF
        let resultIrpf = calculoIRPF(salary: baseParaIRPF)
        descontoIRPF = resultIrpf
        efetivoIRPF = baseParaIRPF > 0 ? (resultIrpf / baseParaIRPF) * 100 : 0
        
        // Desconto adicional informado pelo usuário (se houver)
        let desconto = Double(descontoAdicional) ?? 0.0
        
        //resultado do desconto INSS e IRPF
        descontos = resultInss + resultIrpf + desconto
        
        // Cálculo do salário líquido
        salarioLiquido = salarioB - resultInss - resultIrpf - desconto
        
    }
    
    // Função para calcular o INSS de forma progressiva com base nas faixas vigentes
    func calculoINSS(salary: Double) -> Double {
        var discount = 0.0
        
        if salary <= 1100.00 {
            discount = salary * 0.075
        } else if salary <= 2203.48 {
            discount = (1100.00 * 0.075) + ((salary - 1100.00) * 0.09)
        } else if salary <= 3305.22 {
            discount = (1100.00 * 0.075) +
            ((2203.48 - 1100.00) * 0.09) +
            ((salary - 2203.48) * 0.12)
        } else if salary <= 6433.57 {
            discount = (1100.00 * 0.075) +
            ((2203.48 - 1100.00) * 0.09) +
            ((3305.22 - 2203.48) * 0.12) +
            ((salary - 3305.22) * 0.14)
        } else {
            // Teto máximo do INSS
            discount = (1100.00 * 0.075) +
            ((2203.48 - 1100.00) * 0.09) +
            ((3305.22 - 2203.48) * 0.12) +
            ((6433.57 - 3305.22) * 0.14)
        }
        
        return discount
    }
    
    // Função para calcular o IRRF com base nas faixas e deduções vigentes
    func calculoIRPF(salary: Double) -> Double {
        var discount = 0.0
        
        if salary <= 1903.98 {
            discount = 0
        } else if salary <= 2826.65 {
            discount = salary * 0.075 - 142.80
        } else if salary <= 3751.05 {
            discount = salary * 0.15 - 354.80
        } else if salary <= 4664.68 {
            discount = salary * 0.225 - 636.13
        } else {
            discount = salary * 0.275 - 869.36
        }
        
        return discount > 0 ? discount : 0
    }
}

#Preview {
    ContentView()
}

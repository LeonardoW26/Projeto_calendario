import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trabalho_calendario/dao/calendario_dao.dart';
import 'package:trabalho_calendario/model/calendario.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  // Variáveis de controle do estado do aplicativo
  String _mesSelecionado = 'Janeiro'; // Mês inicial selecionado
  String _anoSelecionado = '2024'; // Ano inicial selecionado
  String _anoSelecionadoDropdown = '2024'; // Ano inicial selecionado na caixa de seleção do ano
  late List<String> _diasDoMes; // Lista para armazenar os dias do mês selecionado
  late Map<String, String> _descricoesDosDias; // Mapa para armazenar as descrições de cada dia
  final _dao = CalendarioDao();

  var _carregando = false;

  void _atualizarLista() async {
    setState(() {
      _carregando = true;
    });

    final lista = await _dao.Lista();
    setState(() {
      _descricoesDosDias = {for (var item in lista) item.dia!: item.descricao!};
      _carregando = false;
    });
  }

  // Variáveis de controle do mouse e do dia selecionado ao passar o mouse
  bool _isMouseOver = false; // Flag para indicar se o mouse está sobre um dia
  String _diaSelecionado = ''; // Dia selecionado ao passar o mouse sobre ele

  @override
  void initState() {
    super.initState();
    _diasDoMes = _calcularDiasDoMes(_mesSelecionado); // Inicializa os dias do mês inicial
    _descricoesDosDias = {}; // Inicializa o mapa vazio para descrições
    _atualizarLista(); // Carrega as descrições dos dias do banco de dados
  }

  @override
  Widget build(BuildContext context) {
    // Construção da interface do aplicativo
    return Scaffold(
      appBar: _criarAppBar(context), // Barra superior do aplicativo
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: _criarCalendario(), // Calendário exibido na tela
            ),
          ),
        ],
      ),
    );
  }

  AppBar _criarAppBar(BuildContext context) {
    // Criação da barra superior do aplicativo
    return AppBar(
      backgroundColor: Colors.blue[700], // Cor de fundo da barra superior
      title: Text('Calendário - $_mesSelecionado $_anoSelecionado'), // Título com mês e ano selecionados
      centerTitle: false,
      actions: [
        IconButton(
          onPressed: () {
            _mostrarSelecaoMes(context); // Função para mostrar a seleção de mês e ano
          },
          icon: Icon(Icons.calendar_today), // Ícone do calendário para seleção de mês e ano
        ),
      ],
    );
  }

  List<String> _calcularDiasDoMes(String mes) {
    // Lógica para calcular os dias de cada mês
    switch (mes) {
      case 'Janeiro':
      case 'Março':
      case 'Maio':
      case 'Julho':
      case 'Agosto':
      case 'Outubro':
      case 'Dezembro':
        return List.generate(31, (index) => (index + 1).toString());
      case 'Fevereiro':
        int ano = int.parse(_anoSelecionado);
        bool bissexto = (ano % 4 == 0 && ano % 100 != 0) || (ano % 400 == 0);
        return bissexto
            ? List.generate(29, (index) => (index + 1).toString())
            : List.generate(28, (index) => (index + 1).toString());
      default:
        return List.generate(30, (index) => (index + 1).toString());
    }
  }

  Widget _criarCalendario() {
    // Criação do calendário na forma de uma grade de dias
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
      ),
      itemCount: _diasDoMes.length,
      itemBuilder: (BuildContext context, int index) {
        final dia = _diasDoMes[index];
        final descricao = _descricoesDosDias[dia] ?? '';

        // Construção visual de cada dia no calendário
        return MouseRegion(
          onEnter: (event) {
            setState(() {
              _isMouseOver = true; // Marca que o mouse está sobre um dia
              _diaSelecionado = dia; // Define o dia selecionado para exibição da borda
            });
          },
          onExit: (event) {
            setState(() {
              _isMouseOver = false; // Marca que o mouse não está mais sobre um dia
              _diaSelecionado = ''; // Limpa o dia selecionado
            });
          },
          child: GestureDetector(
            onTap: () {
              _mostrarDescricao(context, dia, descricao); // Mostra a descrição do dia em um diálogo
            },
            child: Container(
              margin: EdgeInsets.all(3),
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border.all(
                  color: _isMouseOver && _diaSelecionado == dia ? Colors.indigo.shade800 : Colors.grey, // Cor da borda ao passar o mouse
                ),
                color: Colors.transparent,
              ),
              child: Stack(
                children: [
                  if (descricao.isNotEmpty)
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                    ),
                  Positioned(
                    left: 4,
                    bottom: 4,
                    child: GestureDetector(
                      onTap: () {
                        _mostrarEdicaoDescricao(context, dia); // Mostra o diálogo para editar a descrição do dia
                      },
                      child: Icon(Icons.edit, size: 15), // Ícone para editar a descrição
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      dia,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _mostrarDescricao(BuildContext context, String diaSelecionado, String descricao) async {
    // Mostra um diálogo com a descrição do dia selecionado
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Descrição do Dia $diaSelecionado'),
          content: Text(descricao),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _mostrarEdicaoDescricao(BuildContext context, String diaSelecionado) async {
    // Mostra um diálogo para editar a descrição do dia
    TextEditingController descricaoController = TextEditingController();
    descricaoController.text = _descricoesDosDias[diaSelecionado] ?? '';

    String? novaDescricao = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Descrição do Dia $diaSelecionado'),
          content: TextField(
            controller: descricaoController,
            decoration: InputDecoration(labelText: 'Nova Descrição'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                String novaDescricao = descricaoController.text.trim();
                Navigator.pop(context, novaDescricao); // Retorna a nova descrição ao fechar o diálogo
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );

    if (novaDescricao != null) {
      final _calendario = Calendario(descricao: novaDescricao, dia: diaSelecionado);
      await _dao.salvar(_calendario);
      setState(() {
        _descricoesDosDias[diaSelecionado] = novaDescricao; // Atualiza a descrição do dia no mapa
      });
    }
  }

  Future<void> _mostrarSelecaoMes(BuildContext context) async {
    // Mostra um diálogo para selecionar o mês e o ano
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Selecionar Mês e Ano'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: _mesSelecionado,
                items: <String>[
                  'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho', 'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? novoMes) {
                  setState(() {
                    if (novoMes != null) {
                      _mesSelecionado = novoMes; // Atualiza o mês selecionado
                    }
                  });
                },
              ),
              DropdownButton<String>(
                value: _anoSelecionadoDropdown,
                items: List.generate(10, (index) {
                  int ano = DateTime.now().year + index - 5;
                  return DropdownMenuItem<String>(
                    value: ano.toString(),
                    child: Text(ano.toString()),
                  );
                }).toList(),
                onChanged: (String? novoAno) {
                  setState(() {
                    if (novoAno != null) {
                      _anoSelecionadoDropdown = novoAno; // Atualiza o ano selecionado na caixa de seleção
                    }
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Fecha o diálogo sem fazer nada
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _mesSelecionado = _mesSelecionado; // Atualiza o mês selecionado
                  _anoSelecionado = _anoSelecionadoDropdown; // Atualiza o ano selecionado
                  _diasDoMes = _calcularDiasDoMes(_mesSelecionado); // Recalcula os dias do mês
                });
                Navigator.pop(context); // Fecha o diálogo
              },
              child: Text('Selecionar'),
            ),
          ],
        );
      },
    );
  }
}

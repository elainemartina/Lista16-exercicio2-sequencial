      $set sourceformat"free"
      *>Divisão de identificação do programa
       identification division.
       program-id. "lista16exercicio2".
       author. "Elaine Martina Andre.
       installation. "PC".
       date-written. 23/07/2020.
       date-compiled. 23/07/2020.

      *>Divisão para configuração do ambiente
       environment division.
       configuration section.
           special-names. decimal-point is comma.

      *>------------------------------------------------------------------------
      *>-----Declaração dos recursos externos
       input-output section.
       file-control.

           select arqEstadosCap assign to "arqEstadosCap.txt"    *> Select - Add o Nome do Arquivo e Assign - Associa o Arquivo Fisico
           organization is line sequential                       *> Forma de Organização Dos Dados
           access mode is sequential                             *> Acess - Como Vou Acessar o Arquivo
           lock mode is automatic                                *> Para Mais de Um Usuario Usar ao Mesmo Tempo Sem Perder Dados e Sem Ficar Lento
           file status is ws-fs-arqEstadosCap.                   *> File Status- Status da Ultima Operação

       i-o-control.

      *>------------------------------------------------------------------------
      *>Declaração de variáveis
       data division.

      *>----Variaveis de arquivos
       file section.
       fd arqEstadosCap.
       01  fd-estados.
           05 fd-estado                            pic x(25).
           05 fd-capital                           pic x(25).

      *>------------------------------------------------------------------------
      *>----Variaveis de trabalho
       working-storage section.

       77  ws-fs-arqEstadosCap                       pic  9(02).

       01  ws-estados occurs 27.
           05 ws-estado                            pic x(25).
           05 ws-capital                           pic x(25).

       01 ws-jogadores occurs 4.
          05 ws-nome-jog                           pic x(25).
          05 ws-pontos                             pic 9(02) value zero.

       01 ws-jogadores-aux.
          05 ws-nome-jog-aux                       pic x(25).
          05 ws-pontos-aux                         pic 9(02) value zero.

       01 ws-indices.
          05 ws-ind-est                            pic 9(02).
          05 ws-ind-jog                            pic 9(01).

       01 ws-tela-menu.
          05 ws-cadastro-jogadores                 pic x(01).
          05 ws-jogar                              pic x(01).

       01 ws-tela-jogo.
          05 ws-capital-jog                        pic x(25).
          05 ws-estado-sorteado                    pic x(25).
          05 ws-pontos-jogador                     pic 9(02).

       01 ws-uso-comum.
          05 ws-sair                               pic x(01).
          05 ws-msn                                pic x(50).
          05 ws-msn-erro.
             10 ws-msn-erro-ofsset                 pic 9(04).
             10 filler                             pic x(01) value "-".
             10 ws-msn-erro-cod                    pic 9(02).
             10 filler                             pic x(01) value space.
             10 ws-msn-erro-text                   pic x(42).

          05 ws-nome-jogador                       pic x(25).

       01 sorteio.
          05  semente                              pic  9(08).
          05  num_random                           pic  9(01)V9999999.

       01 controle                                 pic x(1).
          88  trocou                               value "1".
          88  nao_trocou                           value "5".
      *>------------------------------------------------------------------------
      *>----Variaveis para comunicação entre programas
       linkage section.

      *>------------------------------------------------------------------------
      *>----Declaração de tela
       screen section.
       01  sc-tela-menu.
      *>                                0    1    1    2    2    3    3    4    4    5    5    6    6    7    7    8
      *>                                5    0    5    0    5    0    5    0    5    0    5    0    5    0    5    0
      *>                            ----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+
           05 blank screen.
           05 line 01 col 01 value "                                                                     [ ]Sair     ".
           05 line 02 col 01 value "                                Tela Principal                                   ".
           05 line 03 col 01 value "      MENU                                                                       ".
           05 line 04 col 01 value "        [ ]Cadastro de Jogadores                                                 ".
           05 line 05 col 01 value "        [ ]Jogar                                                                 ".


           05 sc-sair-menu            line 01  col 71 pic x(01)
           using ws-sair foreground-color 12.

           05 sc-cadastro-jogadores   line 04  col 10 pic x(01)
           using ws-cadastro-jogadores foreground-color 15.

           05 sc-jogar                line 05  col 10 pic x(01)
           using ws-jogar foreground-color 15.
      *>---------------------------------------------------------------------------------------------------------------
       01  sc-tela-cad-jogador.
      *>                                0    1    1    2    2    3    3    4    4    5    5    6    6    7    7    8
      *>                                5    0    5    0    5    0    5    0    5    0    5    0    5    0    5    0
      *>                            ----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+
           05 blank screen.
           05 line 01 col 01 value "                                                                     [ ]Sair     ".
           05 line 02 col 01 value "                                Cadastro de Jogadores                            ".
           05 line 03 col 01 value "                                                                                 ".
           05 line 04 col 01 value "      Jogador  :                                                                 ".
           05 line 22 col 01 value "              [__________________________________________________]               ".


           05 sc-sair-cad-jog            line 01  col 71 pic x(01)
           using ws-sair foreground-color 12.

           05 sc-nome-jog-cad-jog        line 04  col 17 pic x(25)
           using ws-nome-jogador foreground-color 12.

           05 sc-msn-cad-jog             line 22  col 16 pic x(50)
           from ws-msn  foreground-color 12.
      *>---------------------------------------------------------------------------------------------------------------
       01  sc-tela-jogar.
      *>                                0    1    1    2    2    3    3    4    4    5    5    6    6    7    7    8
      *>                                5    0    5    0    5    0    5    0    5    0    5    0    5    0    5    0
      *>                            ----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+
           05 blank screen.
           05 line 01 col 01 value "                                                                     [ ]Sair     ".
           05 line 02 col 01 value "                           Quiz Estados Brasileiros                              ".
           05 line 03 col 01 value "                                                                                 ".
           05 line 04 col 01 value "      Jogador  :                                   Pontos Acumulados:            ".
           05 line 06 col 01 value "      Qual e a capital do estado:                                                ".
           05 line 07 col 01 value "      Resposta :                                                                 ".


           05 line 22 col 01 value "              [__________________________________________________]               ".


           05 sc-sair-jog                line 01  col 71 pic x(01)
           using ws-sair foreground-color 12.

           05 sc-nome-jog                line 04  col 17 pic x(25)
           from ws-nome-jogador foreground-color 12.

           05 sc-pontos-jog              line 04  col 71 pic 9(02)
           from ws-pontos-jogador foreground-color 12.

           05 sc-estado-sorteado-jog     line 06  col 34 pic x(25)
           from ws-estado-sorteado foreground-color 12.


           05 sc-resposta-jog            line 07  col 17 pic x(25)
           using ws-capital-jog  foreground-color 12.


           05 sc-msn-jog                 line 22  col 16 pic x(50)
           from ws-msn  foreground-color 12.

      *>---------------------------------------------------------------------------------------------------------------
       01  sc-tela-relatorio.
      *>                                0    1    1    2    2    3    3    4    4    5    5    6    6    7    7    8
      *>                                5    0    5    0    5    0    5    0    5    0    5    0    5    0    5    0
      *>                            ----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+
           05 blank screen.
           05 line 01 col 01 value "                                                                     [ ]Sair     ".
           05 line 02 col 01 value "                                Resultados finais                                ".
           05 line 03 col 01 value "                                                                                 ".
           05 line 04 col 01 value "  Quarto colocado  :                                        Pontos:              ".
           05 line 05 col 01 value "  Terceiro colocado:                                        Pontos:              ".
           05 line 06 col 01 value "  Segundo colocado :                                        Pontos:              ".
           05 line 07 col 01 value "  Vencedor         :                                        Pontos:              ".
           05 line 22 col 01 value "              [__________________________________________________]               ".


           05 sc-sair-rel                line 01  col 71 pic x(01)
           using ws-sair foreground-color 12.

           05 sc-nome-jog4-rel           line 04  col 21 pic x(25)
           from ws-nome-jog(4) foreground-color 12.

           05 sc-pontos-jog4-rel         line 04  col 68 pic 9(02)
           from ws-pontos(4) foreground-color 12.

           05 sc-nome-jog3-rel           line 05  col 21 pic x(25)
           from ws-nome-jog(3) foreground-color 12.

           05 sc-pontos-jog3-rel         line 05  col 68 pic 9(02)
           from ws-pontos(3) foreground-color 12.

           05 sc-nome-jog2-rel           line 06  col 21 pic x(25)
           from ws-nome-jog(2) foreground-color 12.

           05 sc-pontos-jog2-rel         line 06  col 68 pic 9(02)
           from ws-pontos(2) foreground-color 12.

           05 sc-nome-jog1-rel           line 07  col 21 pic x(25)
           from ws-nome-jog(1) foreground-color 12.

           05 sc-pontos-jog1-rel         line 07  col 68 pic 9(02)
           from ws-pontos(1) foreground-color 12.

           05 sc-msn-rel                 line 22  col 16 pic x(50)
           from ws-msn  foreground-color 12.
      *>---------------------------------------------------------------------------------------------------------------
      *>Declaração do corpo do programa
       procedure division.

           perform inicializa.
           perform processamento.
           perform finaliza.

      *>------------------------------------------------------------------------
      *>                    Procedimentos de Inicialização
      *>------------------------------------------------------------------------
       inicializa section.

      *>   Open Input - Abre o Arquivo Somente Para Leitura
           open input arqEstadosCap.
      *>   Tratamento de Erro - Caso o File Status dê Diferente de Zero (Comando Executado com Sucesso) Aparecerá a Mensagem de Erro na Section Finaliza Anormal
           if  ws-fs-arqEstadosCap <> 0 then
               move 1                                   to ws-msn-erro-ofsset
               move ws-fs-arqEstadosCap                 to ws-msn-erro-cod
               move "Erro ao Abrir Arq. arqEstadosCap " to ws-msn-erro-text
               perform finaliza-anormal
           end-if

      *>   Variar o Indice de Estado até que o File Status Seja Igual a 10 (Fim do Arquivo) ou o Indice Seja Maior Que 27 Estados
           perform varying ws-ind-est from 1 by 1 until ws-fs-arqEstadosCap = 10
                                                     or ws-ind-est > 27
      *>       Ler o Arquivo arqEstadosCap Para Dentro da Variavel de Trabalho do Estado
               read arqEstadosCap into ws-estado(ws-ind-est)
      *>       Tratamento de Erro - Caso o File Status dê Diferente de Zero (Comando Executado com Sucesso) e Dez (Fim do Arquivo) Aparecerá a Mensagem de Erro na Section Finaliza Anormal
               if  ws-fs-arqEstadosCap <> 0
               and ws-fs-arqEstadosCap <> 10  then
                   move 2                                    to ws-msn-erro-ofsset
                   move ws-fs-arqEstadosCap                  to ws-msn-erro-cod
                   move "Erro ao Ler Arq. arqEstadosCap "    to ws-msn-erro-text
                   perform finaliza-anormal
               end-if

           end-perform

      *>   Fechar o Arquivo
           close arqEstadosCap.
      *>       Tratamento de Erro - Caso o File Status dê Diferente de Zero (Comando Executado com Sucesso) Aparecerá a Mensagem de Erro na Section Finaliza Anormal
           if  ws-fs-arqEstadosCap <> 0 then
               move 3                                    to ws-msn-erro-ofsset
               move ws-fs-arqEstadosCap                  to ws-msn-erro-cod
               move "Erro ao Fechar Arq. arqEstadosCap " to ws-msn-erro-text
               perform finaliza-anormal
           end-if

           .
       inicializa-exit.
           exit.
      *>------------------------------------------------------------------------
      *>                       Processamento Principal
      *>------------------------------------------------------------------------
       processamento section.

      *>   Executar Até que Sair Seja "X" ou "x"
           perform until ws-sair = "X"
                      or ws-sair = "x"

      *>       Movendo Espaço Para as Variaveis de Jogadores Para Não Conter Sujeira
               move space  to ws-cadastro-jogadores
               move space  to ws-jogar
               move space  to ws-sair

      *>       Exibindo a Tela do Menu
               display sc-tela-menu
               accept sc-tela-menu

      *>       Se For Selecionado Com "X" ou "x" a Opção Cadastro de Jogadores Chamar a Section de Cadastrar Jogadores
               if  ws-cadastro-jogadores  = "X"
               or  ws-cadastro-jogadores  = "x"  then
                    perform cadastrar-jogadores
               end-if

      *>       Se For Selecionado Com "X" ou "x" a Opção Jogar Chamar a Section Jogar Para Iniciar o Jogo
               if  ws-jogar = "X"
               or  ws-jogar = "x" then
                    perform jogar
               end-if

           end-perform

      *>   Chamar Impressao de Relatorio
           perform relatorio-final

           .
       processamento-exit.
           exit.
      *>------------------------------------------------------------------------
      *>         Cadastro de Jogadores, Sao Admitidos Até 4 Jogadores
      *>------------------------------------------------------------------------
       cadastrar-jogadores section.

      *>   Executar Até que Sair Seja "V" ou "v" e Voltar Para a Tela do Menu Principal
           perform until ws-sair = "V"
                      or ws-sair = "v"

      *>       Movendo Espaço Para a Variavel do Nome do Jogador Para Não Conter Sujeira
               move space  to ws-nome-jogador

      *>       Exibindo a Tela de Cadastro de Jogadores
               display sc-tela-cad-jogador
               accept sc-tela-cad-jogador

      *>       Movendo Espaço Para a Variavel de Mensagem Para Não Conter Sujeira
               move space     to   ws-msn

      *>       Se o Nome do Jogador For Diferente de Espaço Chamar a Section de Descobrir Proximo Indice de Jogador
               if ws-nome-jogador <> space then  *> Consistindo a Digitação do User, Nomes = Spaces  São Ignorados
                   perform descobrir-prox-ind-jog
                   if ws-ind-jog <= 4 then       *> Consistencia da Quantidade de Jogadores Para Evitar Estouro de Tabela
      *>               Salvar Jogador na Tabela de Jogadores
                       move ws-nome-jogador   to  ws-nome-jog(ws-ind-jog)
                   else
      *>               Caso Ocorra Espaço Estouro de Tabela Moverá a Mensagem Abaixo Para o Campo de Mensagem da Tela
                       move "Quantidade de Jogadores Completa" to ws-msn
                   end-if
               end-if

           end-perform
           .
       cadastrar-jogadores-exit.
           exit.
      *>------------------------------------------------------------------------
      *>                             Motor do Jogo
      *>------------------------------------------------------------------------
       jogar section.

      *>   Executar Até que Sair Seja "V" ou "v" e Voltar Para a Tela do Menu Principal
           perform until ws-sair = "V"
                      or ws-sair = "v"

      *>       Executar Variando o Indice de Jogadores de 1 em 1 Ate Que Seja Maior Que 4 ou Tenha Espaço na Variavel ou Coloque "V/v" em Sair
               perform varying  ws-ind-jog  from 1 by 1 until ws-ind-jog > 4
                                                           or  ws-nome-jog(ws-ind-jog) = spaces
                                                           or  ws-sair                 = "V"
                                                           or  ws-sair                 = "v"
      *>           Jogador da rodada...
                   move ws-nome-jog(ws-ind-jog)   to   ws-nome-jogador
                   move ws-pontos(ws-ind-jog)     to   ws-pontos-jogador

      *>           Chamar a Section de Sorteio de Estado
                   perform sorteia-estado
                   move ws-estado(ws-ind-est)     to   ws-estado-sorteado

      *>           Movendo Espaço Para as Variaveis Para Não Conter Sujeira
                   move space                     to   ws-capital-jog
                   move space                     to   ws-msn

      *>           Exibir a Tela de Jogar
                   display sc-tela-jogar
                   accept sc-tela-jogar

      *>           Testar se o Jogador Acertou a Resposta, Caso Acertou Adicionar 1 a Sua Pontuação
                   if ws-capital-jog = ws-capital(ws-ind-est) then
                         add 1 to ws-pontos(ws-ind-jog)
                         move "Acertou!!!"        to ws-msn
                   else
                         move "Errou!!!"          to ws-msn
                   end-if

      *>           Exibir a Tela de Jogar Para O Proximo Jogador
                   display sc-tela-jogar
                   accept sc-tela-jogar

               end-perform

           end-perform

           .
       jogar-exit.
           exit.
      *>------------------------------------------------------------------------
      *>   Descobrir a Proxima Posição Livre Dentro da Tabela de Jogadores
      *>------------------------------------------------------------------------
       descobrir-prox-ind-jog section.

      *>   Executar Variando o Indice de Jogadores de 1 em 1 Ate Que Seja Maior Que 4 ou Tenha Espaço na Variavel
           perform varying ws-ind-jog from 1 by 1 until ws-ind-jog > 4
                                                     or ws-nome-jog(ws-ind-jog) = space
               continue

           end-perform
           .
       descobrir-prox-ind-jog-exit.
           exit.

      *>------------------------------------------------------------------------
      *>                           Sorteia o Estado
      *>------------------------------------------------------------------------
       sorteia-estado section.

      *>    Movendo Espaço Para a Variavel do Indice de Estado Para Não Conter Sujeira
            move zero   to   ws-ind-est
      *>    Executar Até Que o Indice de Estado Seja Diferente de Zero
            perform until ws-ind-est <> 0

      *>       Aceitando a Semente do Numero Randomico
               accept semente from time

      *>       Gerando o Numero Randomico
               compute num_random = function random(semente)

      *>       Multiplicando o Numero Randomico Pela Quantidade de Estados
               multiply num_random by 27 giving ws-ind-est

            end-perform
           .
       sorteia-estado-exit.
           exit.
      *>------------------------------------------------------------------------
      *>                     Imprimindo Relatório Final
      *>------------------------------------------------------------------------
       relatorio-final section.

      *>   Executar Até que Sair Seja "X" ou "x"
           perform until ws-sair = "X"
                      or ws-sair = "x"

      *>       Chamar a Section de Ordenação
               perform ordenar-jogadores

      *>       Movendo Espaço Para as Variaveis Para Não Conter Sujeira
               move space to ws-msn
               move space to ws-sair

      *>       Exibindo a Tela de Relatorio
               display sc-tela-relatorio
               accept sc-tela-relatorio

           end-perform

           .
       relatorio-final-exit.
           exit.
      *>------------------------------------------------------------------------
      *>                  Ordenação da Tabela de Jogadores
      *>------------------------------------------------------------------------
       ordenar-jogadores section.
           set trocou  to true

           perform until nao_trocou
      *>       Movendo 1 Para o Indice de Jogadores
               move 1           to     ws-ind-jog

      *>       Colocand Não Trocou para Verdadeiro
               set nao_trocou   to true

      *>       Executando Até Que o Indice de Jogadores Seja Igual a 4 ou Tenha Espaço no Nome do Jogador
               perform until ws-ind-jog = 4
                          or    ws-nome-jog(ws-ind-jog + 1) = space
      *>
                   if ws-pontos(ws-ind-jog) < ws-pontos(ws-ind-jog + 1) then  *> Critério de Ordenação é "Pontos do Jogador"
      *>               FAZ TROCA...
                       move ws-jogadores(ws-ind-jog + 1)  to  ws-jogadores-aux
                       move ws-jogadores(ws-ind-jog)      to  ws-jogadores(ws-ind-jog + 1)
                       move ws-jogadores-aux              to  ws-jogadores(ws-ind-jog)

                       set trocou         to  true
                   end-if

      *>           Adicionando 1 Para o Indice de Jogadores Para ir Para o Proximo Jogador
                   add  1   to ws-ind-jog

               end-perform

           end-perform

           .
       ordenar-jogadores-exit.
           exit.
      *>------------------------------------------------------------------------
      *>                       Finalização  Anormal
      *>------------------------------------------------------------------------
       finaliza-anormal section.

      *>   Caso Finalize de Forma Anormal a Mensagem de Erro Aparecerá
      *>   A Mensagem é Composta por um Código, o File Status e Uma Descrição do Erro que Está Ocorrendo
           display erase
           display ws-msn-erro

           stop run

           .
       finaliza-anormal-exit.
           exit.
      *>------------------------------------------------------------------------
      *>                        Finalização  Normal
      *>------------------------------------------------------------------------
       finaliza section.

           stop run

           .
       finaliza-exit.
           exit.


